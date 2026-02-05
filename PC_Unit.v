module PC_Unit ( 
    input  wire        clk,
    input  wire [15:0] L1,
	 input  wire  WE,
    output wire [15:0] current_pc
);

   wire [15:0] pc_add_in;
	
    register16 pc_reg (
        .D(L1),
        .clk(clk),
        .w_en(WE),
        .Q(current_pc)
    );

endmodule

