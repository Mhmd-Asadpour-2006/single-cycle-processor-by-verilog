`timescale 1ns/1ps

module tb_DataPath;

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
  // Helpers
  // --------------------
  function [47:0] mk_inst(input [15:0] target, input [15:0] baddr, input [15:0] aaddr);
    begin
      mk_inst = {target, baddr, aaddr}; // مطابق split48_to_3x16
    end
  endfunction

  // write one word into DataMem (only effective when load=1 in your FIXED code)
  task init_data_mem(input [15:0] addr, input [15:0] data);
    begin
      @(negedge clk);
      load          = 1'b1;
      WriteAddress  = addr;
      WriteData     = data;

      // جلوگیری از برنامه‌ریزی اشتباهی instruction mem در این فاز
      WriteAddressInst = 16'h0000;
      WriteDataInst    = 48'h0;
    end
  endtask

  // write one instruction into instruction mem (only effective when load=1)
  task prog_inst_mem(input [15:0] pc_addr, input [47:0] inst);
    begin
      @(negedge clk);
      load             = 1'b1;
      WriteAddressInst = pc_addr;
      WriteDataInst    = inst;

      // جلوگیری از خراب کردن DataMem (باز هم load=1 است و DataMem writeEnable=1)
      // پس یک آدرس ثابت و دیتای ثابت می‌نویسیم که اهمیتی ندارد.
      WriteAddress     = 16'hFFFF;
      WriteData        = 16'h0000;
    end
  endtask

  // --------------------
  // Pretty monitor + self-check
  // --------------------
  reg [15:0] expB;
  reg [15:0] pc_now, pc_next;
  reg        br, br_r;
  reg [15:0] aaddr, baddr, target;
  reg [15:0] a_data, b_data;
  integer    cyc;

  initial begin
    $dumpfile("tb_DataPath_good.vcd");
    $dumpvars(0, tb_DataPath_good);

    $display("------------------------------------------------------------------------------------------------------------");
    $display(" time  | cyc | load |   PC   | target | Baddr  | Aaddr  |  Bdata  |  Adata  |   B(out) | exp(B) | br | br_r | PC_next");
    $display("------------------------------------------------------------------------------------------------------------");

    cyc = 0;
    forever begin
      @(posedge clk);
      #1; // اجازه بده سیگنال‌های ترکیبی settle شوند

      // خواندن سیگنال‌های داخلی DUT
      pc_now  = dut.PCOutIns;
      pc_next = dut.PCInputIns;

      br   = dut.branch;
      br_r = dut.branch_r;

      target = dut.Split3ToL;
      baddr  = dut.BToDataMem;
      aaddr  = dut.AToDataMem;

      a_data = dut.AToSubtractor;
      b_data = dut.BToSubtractor;

      // انتظار: B = b_data - a_data (16-bit wrap)
      expB = b_data - a_data;

      $display("%6t | %3d |  %b   | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h |  %b |  %b   | 0x%04h",
               $time, cyc, load, pc_now, target, baddr, aaddr, b_data, a_data, B, expB, br, br_r, pc_next);

      // self-check فقط در حالت اجرا (load=0)
      if (load == 1'b0) begin
        if (B !== expB) begin
          $display(">>> [ERROR] B mismatch at time %0t: B=0x%04h exp=0x%04h (PC=0x%04h)", $time, B, expB, pc_now);
        end

        // چک ساده‌ی branch: اگر br_r=1 باشد، PC_next باید target باشد
        if (br_r == 1'b1) begin
          if (pc_next !== target) begin
            $display(">>> [ERROR] Branch target mismatch at time %0t: PC_next=0x%04h target=0x%04h", $time, pc_next, target);
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
    // init defaults
    load = 1'b0;
    WriteDataInst = 48'h0;
    WriteAddressInst = 16'h0;
    WriteData = 16'h0;
    WriteAddress = 16'h0;

    // چند سیکل اول (بدون reset، طبیعی است X ببینیم)
    repeat (2) @(posedge clk);

    // ----------------------------------------
    // Phase 1: init DataMem
    // ----------------------------------------
    init_data_mem(16'h0010, 16'h0003); // 3
    init_data_mem(16'h0020, 16'h000A); // 10
    init_data_mem(16'h0030, 16'h0001); // 1
    init_data_mem(16'h0040, 16'h0005); // 5

    // ----------------------------------------
    // Phase 2: program instruction memory
    // format: {target, Baddr, Aaddr}
    //
    // inst @ PC=0: B=mem[0x0020]-mem[0x0010]=10-3=7    -> br=0
    // inst @ PC=1: B=mem[0x0030]-mem[0x0040]=1-5=-4    -> br=1 (NEG)
    // inst @ PC=2: B=mem[0x0040]-mem[0x0030]=5-1=4     -> br=0
    // inst @ PC=3: B=mem[0x0010]-mem[0x0020]=3-10=-7   -> br=1 (NEG)
    //
    // targetها را طوری گذاشتیم که وقتی br_r=1 شد به PC=0006 بپرد
    // (یادت باشد branch_r یک سیکل دیرتر اثر می‌گذارد)
    // ----------------------------------------
    prog_inst_mem(16'h0000, mk_inst(16'h0006, 16'h0020, 16'h0010));
    prog_inst_mem(16'h0001, mk_inst(16'h0006, 16'h0030, 16'h0040));
    prog_inst_mem(16'h0002, mk_inst(16'h0000, 16'h0040, 16'h0030));
    prog_inst_mem(16'h0003, mk_inst(16'h0006, 16'h0010, 16'h0020));
    prog_inst_mem(16'h0004, mk_inst(16'h0000, 16'h0020, 16'h0040));
    prog_inst_mem(16'h0005, mk_inst(16'h0000, 16'h0010, 16'h0030));
    prog_inst_mem(16'h0006, mk_inst(16'h0000, 16'h0040, 16'h0020)); // 5-10=-5

    // پایان load
    @(negedge clk);
    load = 1'b0;
    WriteDataInst = 48'h0;
    WriteAddressInst = 16'h0;
    WriteData = 16'h0;
    WriteAddress = 16'h0;

    // ----------------------------------------
    // Phase 3: Run
    // ----------------------------------------
    repeat (25) @(posedge clk);

    $display("DONE.");
    $finish;
  end

endmodule
