module test_splitter;
    reg [47:0] in48;
    wire [15:0] out0, out1, out2;
    
    split48_to_3x16 uut (
        .in48(in48),
        .out16_0(out0),
        .out16_1(out1),
        .out16_2(out2)
    );
    
    initial begin
        $display("=== Testing split48_to_3x16 ===");
        
        // Test 1: Pattern
        in48 = 48'h1234_5678_9ABC;
        #10;
        $display("Input: %h", in48);
        $display("Outputs: %h, %h, %h", out0, out1, out2);
        $display("Expected: 1234, 5678, 9ABC");
        
        // Test 2: subleq instruction
        in48 = {16'd10, 16'd11, 16'd20};  // a=10, b=11, L=20
        #10;
        $display("\nInput: %h", in48);
        $display("Outputs: %h, %h, %h", out0, out1, out2);
        $display("Expected: 000A, 000B, 0014");
        
        $finish;
    end
endmodule
