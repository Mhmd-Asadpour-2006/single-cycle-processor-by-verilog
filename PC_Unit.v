module PC_Unit (
    input  wire        clk,
    input  wire        branch,
    input  wire [15:0] L1,
    output wire [15:0] current_pc
);
    wire [15:0] pc_plus_1_out;
    wire [15:0] next_pc_val;


    register16 pc_reg (
        .D(next_pc_val),
        .clk(clk),
        .w_en(1'b1),      
        .Q(current_pc)
    );


    fulladder16 pc_adder (
        .A(current_pc),
        .B(16'b0000_0000_0000_0001),
        .c_in(1'b0),
        .c_out(),          
        .sum(pc_plus_1_out)
    );

    mux2to1_16bit pc_mux (
        .A(pc_plus_1_out),
        .B(L1),
        .S(branch),
        .Y(next_pc_val)
    );

endmodule
