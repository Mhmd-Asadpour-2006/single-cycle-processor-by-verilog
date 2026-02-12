`timescale 1ns/1ps

// Strong / verbose testbench for DataPath
// نشان می‌دهد:
//   load, PC, PC+1, PC_next, L, A_addr, B_addr, A_data, B_data, Result, branch, branch_r
// و همچنین self-check (مقایسه Result و مسیر PC_next)

module tb_DataPath_strong;

  // --------------------
  // DUT ports
  // --------------------
  reg         clk;
  reg         load;
  reg  [47:0] WriteDataInst;
  reg  [15:0] WriteAddressInst;
  reg  [15:0] WriteData;
  reg  [15:0] WriteAddress;
  wire [15:0] B;

  // --------------------
  // Instantiate DUT
  // --------------------
  DataPath dut (
    .clk(clk),
    .load(load),
    .WriteDataInst(WriteDataInst),
    .WriteAddressInst(WriteAddressInst),
    .WriteData(WriteData),
    .WriteAddress(WriteAddress),
    .B(B)
  );

  // --------------------
  // Clock: 10ns period
  // --------------------
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  // --------------------
  // Helper: build instruction
  // Instruction format (after fixed splitter): {L, Baddr, Aaddr}
  // --------------------
  function [47:0] mk_inst(
      input [15:0] L,
      input [15:0] Baddr,
      input [15:0] Aaddr
  );
    begin
      mk_inst = {L, Baddr, Aaddr};
    end
  endfunction

  // --------------------
  // Init DataMem word (effective only when load=1)
  // NOTE: since load=1 also enables instruction_memory write,
  // we keep inst write signals at 0 during this phase.
  // --------------------
  task init_data_mem(input [15:0] addr, input [15:0] data);
    begin
      @(negedge clk);
      load = 1'b1;
      WriteAddress = addr;
      WriteData    = data;

      // prevent accidental instruction programming
      WriteAddressInst = 16'h0000;
      WriteDataInst    = 48'h0;

      // wait for write edge
      @(posedge clk);
    end
  endtask

  // --------------------
  // Program one instruction word (effective only when load=1)
  // NOTE: load=1 also writes DataMem, so we write to a dummy address (31).
  // --------------------
  task prog_inst_mem(input [15:0] pc_addr, input [47:0] inst);
    begin
      @(negedge clk);
      load = 1'b1;
      WriteAddressInst = pc_addr;
      WriteDataInst    = inst;

      // dummy DataMem write (addr 31)
      WriteAddress     = 16'd31;
      WriteData        = 16'h0000;

      // wait for write edge
      @(posedge clk);
    end
  endtask

  // --------------------
  // Pretty monitor + self-check
  // (printed each posedge, after small delay for combinational settle)
  // --------------------
  integer cyc;
  reg [15:0] pc_now;
  reg [15:0] pc_add1;
  reg [15:0] pc_next;
  reg [15:0] L;
  reg [15:0] Aaddr, Baddr;
  reg signed [15:0] Adata, Bdata;
  reg signed [15:0] result;
  reg br, br_r;

  initial begin
    $dumpfile("tb_DataPath_strong.vcd");
    $dumpvars(0, tb_DataPath_strong);

    $display("====================================================================================================================");
    $display(" time   | cyc | LD |   PC   | PC+1  | PC_next |   L    | Aaddr | Baddr |   Adata   |   Bdata   |  Result  | br | br_r");
    $display("====================================================================================================================");

    cyc = 0;
    forever begin
      @(posedge clk);
      #1;

      pc_now  = dut.PCOutIns;
      pc_add1 = dut.pcAddOne;
      pc_next = dut.PCInputIns;

      L     = dut.Split3ToL;
      Baddr = dut.BToDataMem;
      Aaddr = dut.AToDataMem;

      Adata  = $signed(dut.AToSubtractor);
      Bdata  = $signed(dut.BToSubtractor);
      result = $signed(dut.subToB);

      br   = dut.branch;
      br_r = dut.branch_r;

      $display("%6t | %3d |  %b | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | %8d | %8d | %8d |  %b |  %b",
               $time, cyc, load,
               pc_now, pc_add1, pc_next, L,
               Aaddr, Baddr,
               Adata, Bdata, result,
               br, br_r);

      // --------------------
      // Self-checks (only when running)
      // --------------------
      if (load == 1'b0) begin
        // Result check: must match B output and must equal Bdata - Adata
        if (B !== dut.subToB) begin
          $display(">>> [ERROR] B output mismatch (B != subToB) at t=%0t: B=0x%04h subToB=0x%04h", $time, B, dut.subToB);
        end
        if ($signed(B) !== (Bdata - Adata)) begin
          $display(">>> [ERROR] Result mismatch at t=%0t: got=%0d exp=%0d", $time, $signed(B), (Bdata - Adata));
        end

        // PC+1 check
        if (pc_add1 !== (pc_now + 16'd1)) begin
          $display(">>> [ERROR] PC+1 mismatch at t=%0t: pc=%0d pcAddOne=%0d", $time, pc_now, pc_add1);
        end

        // PC_next select check
        if (br_r == 1'b1) begin
          if (pc_next !== L) begin
            $display(">>> [ERROR] Branch PC_next mismatch at t=%0t: br_r=1 pc_next=0x%04h L=0x%04h", $time, pc_next, L);
          end
        end else begin
          if (pc_next !== pc_add1) begin
            $display(">>> [ERROR] Normal PC_next mismatch at t=%0t: br_r=0 pc_next=0x%04h pc+1=0x%04h", $time, pc_next, pc_add1);
          end
        end
      end

      cyc = cyc + 1;
    end
  end

  // --------------------
  // Main stimulus
  // --------------------
  initial begin
    // defaults
    load = 1'b1;
    WriteDataInst = 48'h0;
    WriteAddressInst = 16'h0;
    WriteData = 16'h0;
    WriteAddress = 16'h0;

    // let a couple clocks pass in load mode (this also forces PC to become 0)
    repeat (2) @(posedge clk);

    // ----------------------------------------
    // Phase 1: init DataMem (use addresses 1..8)
    // ----------------------------------------
    init_data_mem(16'd1, 16'd3);          // R1 = 3
    init_data_mem(16'd2, 16'd10);         // R2 = 10
    init_data_mem(16'd3, 16'd1);          // R3 = 1
    init_data_mem(16'd4, 16'd5);          // R4 = 5
    init_data_mem(16'd5, 16'hFFFE);       // R5 = -2
    init_data_mem(16'd6, 16'h8000);       // R6 = -32768
    init_data_mem(16'd7, 16'd1);          // R7 = 1
    init_data_mem(16'd8, 16'h7FFF);       // R8 = 32767

    // ----------------------------------------
    // Phase 2: program instruction memory
    // Instruction: {L, Baddr, Aaddr}
    // Result = mem[B] - mem[A]
    // Branch condition = NEG(Result)
    // Branch takes effect 1-cycle later (branch_r) and uses *current* L
    // ----------------------------------------
    // PC=0: 10-3 = 7 (br=0)
    prog_inst_mem(16'd0, mk_inst(16'd0, 16'd2, 16'd1));
    // PC=1: 1-5 = -4 (br=1)  => branch_r=1 next cycle
    prog_inst_mem(16'd1, mk_inst(16'd0, 16'd3, 16'd4));
    // PC=2: delay slot. If previous was negative, jump to L=6.
    //       10-1 = 9 (br=0)  => clears branch_r for next-next
    prog_inst_mem(16'd2, mk_inst(16'd6, 16'd2, 16'd3));
    // PC=3: filler (may be skipped)
    prog_inst_mem(16'd3, mk_inst(16'd0, 16'd1, 16'd1));
    // PC=4: 32767-1 = 32766 (br=0)
    prog_inst_mem(16'd4, mk_inst(16'd0, 16'd8, 16'd7));
    // PC=5: -32768-1 = 0x7FFF (overflow), br=0
    prog_inst_mem(16'd5, mk_inst(16'd0, 16'd6, 16'd7));
    // PC=6: -2-1 = -3 (br=1)
    prog_inst_mem(16'd6, mk_inst(16'd0, 16'd5, 16'd7));
    // PC=7: delay slot for previous negative: set L=8 so branch from PC=6 jumps to 8.
    //       5-10 = -5 (br=1)
    prog_inst_mem(16'd7, mk_inst(16'd8, 16'd4, 16'd2));
    // PC=8: delay slot for previous negative (from PC=7): set L=4 so jump back to 4.
    //       10-3 = 7 (br=0)
    prog_inst_mem(16'd8, mk_inst(16'd4, 16'd2, 16'd1));
    // PC=9: (optional) 3-10=-7
    prog_inst_mem(16'd9, mk_inst(16'd0, 16'd1, 16'd2));

    // ----------------------------------------
    // Phase 3: Run
    // ----------------------------------------
    @(negedge clk);
    load = 1'b0;
    WriteDataInst = 48'h0;
    WriteAddressInst = 16'h0;
    WriteData = 16'h0;
    WriteAddress = 16'h0;

    // run for a while
    repeat (25) @(posedge clk);

    $display("\nDONE.");
    $finish;
  end

endmodule
