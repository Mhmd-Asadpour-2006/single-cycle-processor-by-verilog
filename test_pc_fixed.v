module test_pc_fixed;
    reg clk;
    reg [15:0] L1;
    reg WE;  // 1 بیتی
    wire [15:0] current_pc;
    
    PC_Unit dut (
        .clk(clk),
        .L1(L1),
        .WE(WE),
        .current_pc(current_pc)
    );
    
    initial begin
        clk = 0;
        forever #50 clk = ~clk;
    end
    
    initial begin
        $display("=== Testing Fixed PC Unit ===");
        $display("Time\tclk\tWE\tL1\t\tPC");
        $display("--------------------------------");
        
        // Initial
        WE = 1'b0;
        L1 = 16'h1234;
        #100;
        $display("%0t\t%b\t%b\t%h\t%h", $time, clk, WE, L1, current_pc);
        
        // Enable write
        WE = 1'b1;
        #100;
        $display("%0t\t%b\t%b\t%h\t%h", $time, clk, WE, L1, current_pc);
        
        // Change input
        L1 = 16'h5678;
        #100;
        $display("%0t\t%b\t%b\t%h\t%h", $time, clk, WE, L1, current_pc);
        
        // Disable write - PC shouldn't change
        WE = 1'b0;
        L1 = 16'h9ABC;
        #100;
        $display("%0t\t%b\t%b\t%h\t%h", $time, clk, WE, L1, current_pc);
        
        $display("\nTest Complete");
        $finish;
    end
endmodule
