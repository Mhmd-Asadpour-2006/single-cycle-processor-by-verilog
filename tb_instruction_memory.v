`timescale 1ns/1ps

module tb_instruction_memory_48;

    reg clk;
    reg writeEnable;
    reg [15:0] writeAddress;
    reg [47:0] writeData;
    reg [15:0] readAddress1;
    reg [15:0] readAddress2;

    wire [47:0] registerData1;
    wire [47:0] registerData2;

    // Instantiate DUT
    instruction_memory uut (
        .clk(clk),
        .writeEnable(writeEnable),
        .writeAddress(writeAddress),
        .writeData(writeData),
        .readAddress1(readAddress1),
        .readAddress2(readAddress2),
        .registerData1(registerData1),
        .registerData2(registerData2)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Init
        clk = 0;
        writeEnable = 0;
        writeAddress = 16'd0;
        writeData = 48'd0;
        readAddress1 = 16'd0;
        readAddress2 = 16'd0;

        $display("=== START TEST ===");

        // =============================
        // Test 1: Write & Read Register 5
        // =============================
        @(posedge clk);
        writeEnable  = 1;
        writeAddress = 16'd5;
        writeData    = 48'h0001_2222_3333;

        @(posedge clk);
        writeEnable = 0;

        readAddress1 = 16'd5;
        #1;
        if (registerData1 !== 48'h0001_2222_3333)
            $display("❌ TEST 1 FAIL");
        else
            $display("✅ TEST 1 PASS");

        // =============================
        // Test 2: Write Register 12
        // =============================
        @(posedge clk);
        writeEnable  = 1;
        writeAddress = 16'd12;
        writeData    = 48'hAAAA_BBBB_CCCC;

        @(posedge clk);
        writeEnable = 0;

        readAddress1 = 16'd12;
        readAddress2 = 16'd5;
        #1;
        if (registerData1 !== 48'hAAAA_BBBB_CCCC ||
            registerData2 !== 48'h0001_2222_3333)
            $display("❌ TEST 2 FAIL");
        else
            $display("✅ TEST 2 PASS");

        // =============================
        // Test 3: Write Disabled
        // =============================
        @(posedge clk);
        writeEnable  = 0;
        writeAddress = 16'd12;
        writeData    = 48'hFFFF_FFFF_FFFF;

        @(posedge clk);
        readAddress1 = 16'd12;
        #1;
        if (registerData1 !== 48'hAAAA_BBBB_CCCC)
            $display("❌ TEST 3 FAIL");
        else
            $display("✅ TEST 3 PASS");

        // =============================
        // Test 4: Two Reads Same Time
        // =============================
        readAddress1 = 16'd5;
        readAddress2 = 16'd12;
        #1;
        if (registerData1 !== 48'h0001_2222_3333 ||
            registerData2 !== 48'hAAAA_BBBB_CCCC)
            $display("❌ TEST 4 FAIL");
        else
            $display("✅ TEST 4 PASS");

        $display("=== END TEST ===");
        $stop;
    end

endmodule
