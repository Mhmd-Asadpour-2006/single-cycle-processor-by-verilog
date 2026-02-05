`timescale 1ns/1ps
module test_subtractor;
    reg [15:0] A, B;
    wire [15:0] res;
    wire NEG;
    
    subtractor uut (
        .A(A),
        .B(B),
        .res(res),
        .NEG(NEG)
    );
    
    initial begin
        $display("=== Testing Subtractor ===");
        $display("A\tB\tres\tNEG\tExpected");
        $display("--------------------------------");
        
        // Test 1: 5 - 10 = -5 (negative)
        A = 16'd5;
        B = 16'd10;
        #10;
        $display("%d\t%d\t%d\t%b\t-5, 1", A, B, $signed(res), NEG);
        
        // Test 2: 10 - 5 = 5 (positive)
        A = 16'd10;
        B = 16'd5;
        #10;
        $display("%d\t%d\t%d\t%b\t5, 0", A, B, $signed(res), NEG);
        
        // Test 3: 10 - 10 = 0 (not negative)
        A = 16'd10;
        B = 16'd10;
        #10;
        $display("%d\t%d\t%d\t%b\t0, 0", A, B, $signed(res), NEG);
        
        $finish;
    end
endmodule
