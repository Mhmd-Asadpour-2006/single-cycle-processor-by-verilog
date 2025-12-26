`timescale 1ns/1ps

module tb_data_memory;
    // Signals
    reg [15:0] readAddress1, readAddress2;
    reg [15:0] writeAddress, writeData;
    reg clk, writeEnable;
    wire [15:0] registerData1, registerData2;
    
    // Test counter
    integer test_num;
    integer errors;
    
    // Instantiate the data_memory
    data_memory uut (
        .readAddress1(readAddress1),
        .readAddress2(readAddress2),
        .writeAddress(writeAddress),
        .writeData(writeData),
        .clk(clk),
        .writeEnable(writeEnable),
        .registerData1(registerData1),
        .registerData2(registerData2)
    );
    
    // Clock generation: 10ns period (100MHz)
    initial clk = 0;
    always #5 clk = ~clk;
    
    // Test procedure
    initial begin
        // Initialize
        test_num = 0;
        errors = 0;
        writeEnable = 0;
        writeAddress = 0;
        writeData = 0;
        readAddress1 = 0;
        readAddress2 = 0;
        
        // Wait for initial settling
        repeat(2) @(posedge clk);
        
        $display("\n");
        $display("========================================");
        $display("     DATA MEMORY TEST - START");
        $display("========================================");
        $display("\n");
        
        // =====================================
        // TEST 1: Write to R5
        // =====================================
        test_num = test_num + 1;
        $display("[TEST %0d] Writing 0xAAAA to R5...", test_num);
        
        @(posedge clk);
        writeEnable = 1;
        writeAddress = 5;
        writeData = 16'hAAAA;
        
        @(posedge clk);  // Data written on this edge
        writeEnable = 0;
        
        @(posedge clk);  // Wait for data to settle
        #1;  // Small delay for combinational logic
        
        readAddress1 = 5;
        readAddress2 = 0;
        #1;
        
        if (registerData1 == 16'hAAAA)
            $display("  ✓ PASS: R5 = 0x%h", registerData1);
        else begin
            $display("  ✗ FAIL: R5 = 0x%h (Expected: 0xAAAA)", registerData1);
            errors = errors + 1;
        end
        
        if (registerData2 == 16'h0000)
            $display("  ✓ PASS: R0 = 0x%h (should always be 0)", registerData2);
        else begin
            $display("  ✗ FAIL: R0 = 0x%h (Expected: 0x0000)", registerData2);
            errors = errors + 1;
        end
        
        // =====================================
        // TEST 2: Write to R1
        // =====================================
        test_num = test_num + 1;
        $display("\n[TEST %0d] Writing 0x1111 to R1...", test_num);
        
        @(posedge clk);
        writeEnable = 1;
        writeAddress = 1;
        writeData = 16'h1111;
        
        @(posedge clk);
        writeEnable = 0;
        
        @(posedge clk);
        #1;
        
        readAddress1 = 1;
        readAddress2 = 5;
        #1;
        
        if (registerData1 == 16'h1111)
            $display("  ✓ PASS: R1 = 0x%h", registerData1);
        else begin
            $display("  ✗ FAIL: R1 = 0x%h (Expected: 0x1111)", registerData1);
            errors = errors + 1;
        end
        
        if (registerData2 == 16'hAAAA)
            $display("  ✓ PASS: R5 = 0x%h (unchanged)", registerData2);
        else begin
            $display("  ✗ FAIL: R5 = 0x%h (Expected: 0xAAAA)", registerData2);
            errors = errors + 1;
        end
        
        // =====================================
        // TEST 3: Write to R2
        // =====================================
        test_num = test_num + 1;
        $display("\n[TEST %0d] Writing 0x2222 to R2...", test_num);
        
        @(posedge clk);
        writeEnable = 1;
        writeAddress = 2;
        writeData = 16'h2222;
        
        @(posedge clk);
        writeEnable = 0;
        
        @(posedge clk);
        #1;
        
        readAddress1 = 2;
        readAddress2 = 1;
        #1;
        
        if (registerData1 == 16'h2222)
            $display("  ✓ PASS: R2 = 0x%h", registerData1);
        else begin
            $display("  ✗ FAIL: R2 = 0x%h (Expected: 0x2222)", registerData1);
            errors = errors + 1;
        end
        
        if (registerData2 == 16'h1111)
            $display("  ✓ PASS: R1 = 0x%h (unchanged)", registerData2);
        else begin
            $display("  ✗ FAIL: R1 = 0x%h (Expected: 0x1111)", registerData2);
            errors = errors + 1;
        end
        
        // =====================================
        // TEST 4: Overwrite R5
        // =====================================
        test_num = test_num + 1;
        $display("\n[TEST %0d] Overwriting R5 with 0xABCD...", test_num);
        
        @(posedge clk);
        writeEnable = 1;
        writeAddress = 5;
        writeData = 16'hABCD;
        
        @(posedge clk);
        writeEnable = 0;
        
        @(posedge clk);
        #1;
        
        readAddress1 = 5;
        readAddress2 = 2;
        #1;
        
        if (registerData1 == 16'hABCD)
            $display("  ✓ PASS: R5 = 0x%h (overwritten)", registerData1);
        else begin
            $display("  ✗ FAIL: R5 = 0x%h (Expected: 0xABCD)", registerData1);
            errors = errors + 1;
        end
        
        if (registerData2 == 16'h2222)
            $display("  ✓ PASS: R2 = 0x%h (unchanged)", registerData2);
        else begin
            $display("  ✗ FAIL: R2 = 0x%h (Expected: 0x2222)", registerData2);
            errors = errors + 1;
        end
        
        // =====================================
        // TEST 5: Write when writeEnable = 0
        // =====================================
        test_num = test_num + 1;
        $display("\n[TEST %0d] Attempting write with writeEnable=0...", test_num);
        
        @(posedge clk);
        writeEnable = 0;  // Disabled!
        writeAddress = 5;
        writeData = 16'hFFFF;
        
        @(posedge clk);
        @(posedge clk);
        #1;
        
        readAddress1 = 5;
        #1;
        
        if (registerData1 == 16'hABCD)
            $display("  ✓ PASS: R5 = 0x%h (unchanged, write disabled)", registerData1);
        else begin
            $display("  ✗ FAIL: R5 = 0x%h (Expected: 0xABCD)", registerData1);
            errors = errors + 1;
        end
        
        // =====================================
        // TEST 6: Simultaneous Read/Write
        // =====================================
        test_num = test_num + 1;
        $display("\n[TEST %0d] Simultaneous write to R10 and read...", test_num);
        
        @(posedge clk);
        writeEnable = 1;
        writeAddress = 10;
        writeData = 16'hBEEF;
        readAddress1 = 10;
        
        @(posedge clk);
        writeEnable = 0;
        
        @(posedge clk);
        #1;
        
        if (registerData1 == 16'hBEEF)
            $display("  ✓ PASS: R10 = 0x%h", registerData1);
        else begin
            $display("  ✗ FAIL: R10 = 0x%h (Expected: 0xBEEF)", registerData1);
            errors = errors + 1;
        end
        
        // =====================================
        // TEST 7: Multiple registers verification
        // =====================================
        test_num = test_num + 1;
        $display("\n[TEST %0d] Verifying all written registers...", test_num);
        
        @(posedge clk);
        readAddress1 = 1; readAddress2 = 2;
        #1;
        $display("  R1=0x%h, R2=0x%h", registerData1, registerData2);
        if (registerData1 != 16'h1111 || registerData2 != 16'h2222) errors = errors + 1;
        
        @(posedge clk);
        readAddress1 = 5; readAddress2 = 10;
        #1;
        $display("  R5=0x%h, R10=0x%h", registerData1, registerData2);
        if (registerData1 != 16'hABCD || registerData2 != 16'hBEEF) errors = errors + 1;
        
        // =====================================
        // TEST 8: R0 write protection
        // =====================================
        test_num = test_num + 1;
        $display("\n[TEST %0d] Testing R0 write protection...", test_num);
        
        @(posedge clk);
        writeEnable = 1;
        writeAddress = 0;
        writeData = 16'hDEAD;
        
        @(posedge clk);
        writeEnable = 0;
        
        @(posedge clk);
        #1;
        
        readAddress1 = 0;
        #1;
        
        if (registerData1 == 16'h0000)
            $display("  ✓ PASS: R0 = 0x%h (write protected)", registerData1);
        else begin
            $display("  ✗ FAIL: R0 = 0x%h (should remain 0x0000)", registerData1);
            errors = errors + 1;
        end
        
        // =====================================
        // Final Summary
        // =====================================
        repeat(3) @(posedge clk);
        
        $display("\n");
        $display("========================================");
        $display("     DATA MEMORY TEST - SUMMARY");
        $display("========================================");
        $display("Total Tests: %0d", test_num);
        $display("Errors: %0d", errors);
        
        if (errors == 0) begin
            $display("\n🎉 ALL TESTS PASSED! 🎉\n");
        end else begin
            $display("\n❌ SOME TESTS FAILED ❌\n");
        end
        
        $display("========================================\n");
        
        $stop;
    end
    
    // Timeout protection
    initial begin
        #2000;
        $display("\n⚠️  ERROR: Testbench timeout!");
        $stop;
    end
    
endmodule
