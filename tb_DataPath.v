`timescale 1ns/1ps

module tb_DataPath;

    // =============================
    // Inputs to DUT
    // =============================
    reg clk;
    reg Activate;
    reg [47:0] WriteData;
    reg [15:0] WriteAddress;

    // =============================
    // Outputs from DUT
    // =============================
    wire Lt;
    wire gt;

    // =============================
    // Instantiate DUT
    // =============================
    DataPath dut (
        .clk(clk),
        .Activate(Activate),
        .WriteData(WriteData),
        .WriteAddress(WriteAddress),
        .Lt(Lt),
        .gt(gt)
    );

    // =============================
    // Clock generation (10ns period)
    // =============================
    always #5 clk = ~clk;

    // =============================
    // Test sequence
    // =============================
    initial begin
        // -----------------------------
        // Initial values
        // -----------------------------
        clk          = 0;
        Activate     = 0;
        WriteData    = 48'd0;
        WriteAddress = 16'd0;

        $display("=================================");
        $display(" START DATAPATH TEST ");
        $display("=================================");

        // -----------------------------
        // Load instruction 0
        // -----------------------------
        @(posedge clk);
        Activate     = 1;
        WriteAddress = 16'd0;
        WriteData    = {16'd5, 16'd3, 16'd10};  
        // A=5 , B=3 , L=10 (branch target)

        @(posedge clk);
        Activate = 0;

        // -----------------------------
        // Load instruction 1
        // -----------------------------
        @(posedge clk);
        Activate     = 1;
        WriteAddress = 16'd1;
        WriteData    = {16'd2, 16'd8, 16'd4};

        @(posedge clk);
        Activate = 0;

        // -----------------------------
        // Let datapath run
        // -----------------------------
        repeat (6) @(posedge clk);

        // -----------------------------
        // Check comparator result
        // -----------------------------
        $display("Lt = %b , gt = %b", Lt, gt);

        if (Lt === 1'b1)
            $display("INFO: A < B detected");
        else if (gt === 1'b1)
            $display("INFO: A > B detected");
        else
            $display("INFO: A == B or undefined");

        // -----------------------------
        // Finish simulation
        // -----------------------------
        $display("=================================");
        $display(" END DATAPATH TEST ");
        $display("=================================");

        $stop;
    end

endmodule
