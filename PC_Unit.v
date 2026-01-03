module PC_Unit (
    input  wire        clk,
    input  wire        branch,
    input  wire [15:0] L1,
    output wire [15:0] current_pc
);

    wire [15:0] pc_add_in;     
    wire [15:0] next_pc_val;


    register16 pc_reg (
        .D(next_pc_val),
        .clk(clk),
        .w_en(1'b1),
        .Q(current_pc)
    );


    mux2to1_16bit pc_mux (
        .A(16'b0000_0000_0000_0001), 
        .B(L1),                      
        .S(branch),
        .Y(pc_add_in)
    );


    fulladder16 pc_adder (
        .A(current_pc),
        .B(pc_add_in),
        .c_in(1'b0),
        .c_out(),
        .sum(next_pc_val)
    );

endmodule

