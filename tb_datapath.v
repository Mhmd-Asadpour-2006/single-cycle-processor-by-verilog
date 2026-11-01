`timescale 1ns/1ps
// ============================================================================
// tb_datapath_full.v  -  verbose self-checking testbench for DataPath (SUBLEQ)
//
// * Instantiates the real DataPath (top level).
// * Every example: (1) loads program + data, (2) runs, printing ONE LINE PER
//   CLOCK with the real values seen inside the DUT, (3) compares them with an
//   independent reference model every cycle, (4) checks hand-computed final
//   values (so correctness does not depend only on the model).
// * Inputs only change on the falling clock edge; checks are done 1 ns after
//   the rising edge, so there are no race / delay problems.
//
// Instruction (48 bit) = { A[15:0], B[15:0], L[15:0] }
//   m[B] = m[B] - m[A];   if (result <= 0) PC = L; else PC = PC + 1
//   (BRANCH_LE = 0 -> reference uses  result < 0  instead)
// Unused instruction slots are filled with  SUBLEQ 0,0,<self>  = HALT.
// ============================================================================
module tb_datapath_full;
    parameter BRANCH_LE = 1;

    reg clk = 0;  always #5 clk = ~clk;
    reg load = 0; reg [47:0] WDI = 0; reg [15:0] WAI = 0, WD = 0, WA = 0;
    wire [15:0] Bout;

    DataPath dut (.clk(clk), .load(load), .WriteDataInst(WDI), .WriteAddressInst(WAI),
                  .WriteData(WD), .WriteAddress(WA), .B(Bout));

    wire [511:0] dm = { dut.DataMem.r31_out, dut.DataMem.r30_out, dut.DataMem.r29_out, dut.DataMem.r28_out, dut.DataMem.r27_out, dut.DataMem.r26_out, dut.DataMem.r25_out, dut.DataMem.r24_out, dut.DataMem.r23_out, dut.DataMem.r22_out, dut.DataMem.r21_out, dut.DataMem.r20_out, dut.DataMem.r19_out, dut.DataMem.r18_out, dut.DataMem.r17_out, dut.DataMem.r16_out, dut.DataMem.r15_out, dut.DataMem.r14_out, dut.DataMem.r13_out, dut.DataMem.r12_out, dut.DataMem.r11_out, dut.DataMem.r10_out, dut.DataMem.r9_out, dut.DataMem.r8_out, dut.DataMem.r7_out, dut.DataMem.r6_out, dut.DataMem.r5_out, dut.DataMem.r4_out, dut.DataMem.r3_out, dut.DataMem.r2_out, dut.DataMem.r1_out, dut.DataMem.r0_out };           // snapshot of the 32 data words

    reg [47:0] prog [0:31];
    reg [15:0] dinit [0:31];
    reg [15:0] rm [0:31];
    reg [15:0] rpc;

    integer nex = 0, ex_err = 0, total_checks = 0, total_err = 0, rnd;
    reg [8*72-1:0] cur_name;
    reg [8*72-1:0] ex_name [0:31];
    reg            ex_ok   [0:31];

    function [47:0] I; input [15:0] a, b, l; I = {a, b, l}; endfunction

    // ------------------------------------------------------------ helpers
    task start_ex; input [8*72-1:0] nm; integer k; begin
        cur_name = nm; ex_err = 0;
        for (k = 0; k < 32; k = k + 1) begin prog[k] = I(16'd0, 16'd0, k[15:0]); dinit[k] = 16'd0; end
        $display("");
        $display("==================================================================");
        $display(" EXAMPLE %0d: %0s", nex + 1, nm);
        $display("==================================================================");
    end endtask

    task show_setup; integer k; begin
        $display(" Program (unlisted slots = HALT):");
        for (k = 0; k < 32; k = k + 1)
            if (prog[k] !== I(16'd0, 16'd0, k[15:0]))
                $display("   I%0d: SUBLEQ A=%0d B=%0d L=%0d   // m[%0d] -= m[%0d]; if result<=0 goto %0d else I%0d",
                         k, prog[k][47:32], prog[k][31:16], prog[k][15:0],
                         prog[k][31:16], prog[k][47:32], prog[k][15:0], k + 1);
        $display(" Initial data (non-zero words):");
        for (k = 0; k < 32; k = k + 1)
            if (dinit[k] !== 16'd0) $display("   m[%0d] = %0d", k, $signed(dinit[k]));
    end endtask

    task bump; input integer n; begin total_err = total_err + n; ex_err = ex_err + n; end endtask

    task exp_mem; input [15:0] ad; input [15:0] v; begin
        total_checks = total_checks + 1;
        if (dm[ad*16 +: 16] === v) $display("   CHECK m[%0d] = %0d  (expected %0d)  OK", ad, $signed(dm[ad*16 +: 16]), $signed(v));
        else begin $display("   CHECK m[%0d] = %0d  (expected %0d)  <<<<< ERROR", ad, $signed(dm[ad*16 +: 16]), $signed(v)); bump(1); end
    end endtask

    task exp_pc; input [15:0] v; begin
        total_checks = total_checks + 1;
        if (dut.PCOutIns === v) $display("   CHECK final PC = %0d  (expected %0d)  OK", dut.PCOutIns, v);
        else begin $display("   CHECK final PC = %0d  (expected %0d)  <<<<< ERROR", dut.PCOutIns, v); bump(1); end
    end endtask

    task end_ex; begin
        ex_name[nex] = cur_name; ex_ok[nex] = (ex_err == 0); nex = nex + 1;
        if (ex_err == 0) $display(" ==> EXAMPLE RESULT: PASS");
        else             $display(" ==> EXAMPLE RESULT: FAIL (%0d errors)", ex_err);
    end endtask

    // ------------------------------------------------------------ load + run
    task run_ex; input integer maxc; input verbose; input stop_halt;
        integer c, k, bad; reg [47:0] ins; reg [15:0] a, b, l, ma, mb, res, npc, oldpc;
        reg br, halted; reg [15:0] dPC, dA, dB, dR, dN; reg dBr;
    begin
        if (verbose) show_setup;
        // ---- load phase: one instruction + one data word per clock
        for (k = 0; k < 32; k = k + 1) begin
            @(negedge clk); load = 1; WAI = k; WDI = prog[k]; WA = k; WD = dinit[k];
        end
        @(negedge clk); load = 0; WAI = 0; WDI = 0; WA = 0; WD = 0;
        for (k = 0; k < 32; k = k + 1) rm[k] = dinit[k];
        rpc = 0; halted = 0; c = 0;
        #1;
        total_checks = total_checks + 1;
        bad = 0;
        if (dut.PCOutIns !== 16'd0) begin bad = bad + 1; $display("   ERROR: PC is %0d after load, expected 0", dut.PCOutIns); end
        for (k = 0; k < 32; k = k + 1) if (dm[k*16 +: 16] !== dinit[k]) begin bad = bad + 1; $display("   ERROR: data memory word %0d not loaded correctly", k); end
        bump(bad);
        if (verbose) begin
            $display(" Execution trace (values read from inside the DUT):");
            $display("  cyc | PC | A  B  L  |  m[B]  -  m[A]  =  result | <=0 | next PC | status");
        end
        while (c < maxc && !halted) begin
            // ---- values BEFORE the clock edge (combinational, settled)
            dPC = dut.PCOutIns; dA = dut.AToSubtractor; dB = dut.BToSubtractor;
            dR = dut.subToB; dBr = dut.branch; dN = dut.PCInputIns;
            // ---- reference model
            ins = prog[rpc[4:0]]; a = ins[47:32]; b = ins[31:16]; l = ins[15:0];
            ma = rm[a[4:0]]; mb = rm[b[4:0]]; res = mb - ma;
            br = BRANCH_LE ? (res[15] | (res == 16'd0)) : res[15];
            npc = br ? l : rpc + 16'd1; oldpc = rpc;
            bad = 0;
            if (dPC !== rpc) bad = bad + 1;
            if (dA  !== ma)  bad = bad + 1;
            if (dB  !== mb)  bad = bad + 1;
            if (dR  !== res) bad = bad + 1;
            if (dBr !== br)  bad = bad + 1;
            if (dN  !== npc) bad = bad + 1;
            // ---- clock edge
            @(posedge clk); #1;
            rm[b[4:0]] = res; rpc = npc;
            if (dut.PCOutIns !== rpc) bad = bad + 1;
            for (k = 0; k < 32; k = k + 1) if (dm[k*16 +: 16] !== rm[k]) bad = bad + 1;
            total_checks = total_checks + 1;
            if (verbose)
                $display("  %3d | %2d | %2d %2d %2d | %6d - %6d = %6d |  %b  |   %2d    | %0s", c, dPC, a, b, l,
                         $signed(dB), $signed(dA), $signed(dR), dBr, dut.PCOutIns, bad == 0 ? "ok" : "<<<<< MISMATCH");
            if (bad != 0 && !verbose) $display("   MISMATCH at cycle %0d (PC=%0d): dut pc/A/B/res/br = %0d/%0d/%0d/%0d/%b  ref = %0d/%0d/%0d/%0d/%b",
                         c, rpc, dPC, $signed(dA), $signed(dB), $signed(dR), dBr, oldpc, $signed(ma), $signed(mb), $signed(res), br);
            bump(bad);
            if (stop_halt && npc == oldpc) halted = 1;
            c = c + 1;
        end
        if (stop_halt) begin
            total_checks = total_checks + 1;
            if (halted) begin if (verbose) $display("  --> HALT reached (jump to itself) after %0d cycles", c); end
            else begin $display("  --> ERROR: program did not halt within %0d cycles", maxc); bump(1); end
        end else if (verbose) $display("  --> ran %0d cycles", c);
    end endtask

    // ------------------------------------------------------------ random example
    task rand_ex; input integer seed; input integer cycles; integer k, s, r; begin
        s = seed; r = $random(s);
        start_ex("Random program vs reference model (quiet)");
        for (k = 0; k < 32; k = k + 1) begin
            case ({$random(s)} % 6)
                0: dinit[k] = 16'd0;      1: dinit[k] = 16'h7FFF;     2: dinit[k] = 16'h8000;
                3: dinit[k] = {$random(s)} % 8;  4: dinit[k] = -({$random(s)} % 8);  default: dinit[k] = $random(s);
            endcase
            prog[k] = I({$random(s)} % 32, {$random(s)} % 32, {$random(s)} % 40);
        end
        $display(" seed=%0d, %0d cycles, only mismatches are printed", seed, cycles);
        run_ex(cycles, 0, 0);
        end_ex;
    end endtask

    // ============================================================ the examples
    integer q;
    initial begin
        $dumpfile("tb_datapath_full.vcd"); $dumpvars(0, tb_datapath_full);

        // ---- 1
        start_ex("Plain subtraction, result stays positive (no branch)");
        dinit[1] = 10; dinit[2] = 3;
        prog[0] = I(2, 1, 30); prog[1] = I(2, 1, 30); prog[2] = I(2, 1, 30);
        run_ex(20, 1, 1);
        exp_mem(1, 1); exp_mem(2, 3); exp_pc(3);
        end_ex;

        // ---- 2
        start_ex("Branch taken on NEGATIVE result (I1 must be skipped)");
        dinit[1] = 2; dinit[2] = 5; dinit[4] = 1; dinit[5] = 100; dinit[6] = 50;
        prog[0] = I(2, 1, 7); prog[1] = I(4, 5, 30); prog[7] = I(4, 6, 30);
        run_ex(20, 1, 1);
        exp_mem(1, -3); exp_mem(5, 100); exp_mem(6, 49); exp_pc(8);
        end_ex;

        // ---- 3
        start_ex("Boundary: result == 0 must branch, result == 1 must not");
        dinit[1] = 4; dinit[2] = 4; dinit[4] = 1; dinit[8] = 100; dinit[10] = 2; dinit[11] = 1;
        prog[0] = I(2, 1, 5); prog[1] = I(4, 8, 30); prog[5] = I(11, 10, 30);
        run_ex(20, 1, 1);
        exp_mem(1, 0); exp_mem(8, 100); exp_mem(10, 1); exp_pc(6);
        end_ex;

        // ---- 4
        start_ex("Same address A == B  (x - x = 0, branch taken)");
        dinit[3] = 77; dinit[5] = 1; dinit[8] = 100;
        prog[0] = I(3, 3, 4); prog[1] = I(5, 8, 30);
        run_ex(20, 1, 1);
        exp_mem(3, 0); exp_mem(8, 100); exp_pc(4);
        end_ex;

        // ---- 5
        start_ex("Addition 7 + 5 built from 3 SUBLEQ instructions");
        dinit[1] = 7; dinit[2] = 5; dinit[3] = 0;
        prog[0] = I(2, 3, 1);   // T = T - Y   (T = -5)
        prog[1] = I(3, 1, 2);   // X = X - T   (X = 12)
        prog[2] = I(3, 3, 3);   // T = 0
        run_ex(20, 1, 1);
        exp_mem(1, 12); exp_mem(2, 5); exp_mem(3, 0); exp_pc(3);
        end_ex;

        // ---- 6
        start_ex("Loop: multiplication 6 x 7 by repeated addition");
        dinit[1] = 6; dinit[2] = 7; dinit[4] = 0; dinit[5] = 1; dinit[6] = 0;
        prog[0] = I(2, 6, 1);   // T   = -M
        prog[1] = I(6, 4, 2);   // ACC = ACC + M
        prog[2] = I(6, 6, 3);   // T   = 0
        prog[3] = I(5, 1, 5);   // C   = C - 1 ; if C <= 0 goto END(5)
        prog[4] = I(0, 0, 0);   // unconditional jump to I0
        run_ex(80, 1, 1);
        exp_mem(4, 42); exp_mem(1, 0); exp_mem(6, 0); exp_pc(5);
        end_ex;

        // ---- 7
        start_ex("16-bit wrap-around (no overflow detection in hardware)");
        dinit[1] = 16'h8000; dinit[2] = 1; dinit[3] = 16'h7FFF; dinit[4] = 16'hFFFF;
        prog[0] = I(2, 1, 29);  // 0x8000 - 1 = 0x7FFF  (wraps, positive -> no branch)
        prog[1] = I(4, 3, 30);  // 0x7FFF - (-1) = 0x8000 (wraps, negative -> branch)
        run_ex(20, 1, 1);
        exp_mem(1, 16'h7FFF); exp_mem(3, 16'h8000); exp_pc(30);
        end_ex;

        // ---- 8..11 random programs
        for (q = 1; q <= 4; q = q + 1) rand_ex(1000 + q * 7919, 150);

        // ============================================================ summary
        $display("");
        $display("==================================================================");
        $display(" SUMMARY");
        $display("==================================================================");
        for (q = 0; q < nex; q = q + 1)
            $display("  %2d. %0s : %0s", q + 1, ex_name[q], ex_ok[q] ? "PASS" : "FAIL");
        $display("  checks performed: %0d, errors: %0d", total_checks, total_err);
        if (total_err == 0) $display("  >>> ALL %0d EXAMPLES PASSED <<<", nex);
        else                $display("  >>> TESTBENCH FAILED <<<");
        $finish;
    end
endmodule
