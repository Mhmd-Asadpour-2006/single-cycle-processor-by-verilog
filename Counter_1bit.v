module Counter_1bit(
    input clk,
    output number
);
	
	wire d_input;
	wire q_output;
	
	not(d_input,q_output);

	d_flipflop dff(
    .Q(q_output),
	 .D(d_input),
	 .clk(clk)
	);
	
	buf(number,q_output);
	

endmodule
