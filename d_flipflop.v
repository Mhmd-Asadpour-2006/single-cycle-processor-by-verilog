module d_flipflop(
    output reg Q,
	 input wire D,
	 input wire clk
);
    always @(posedge clk) begin
		if (D !== 1'b0 && D !== 1'b1)
			Q <= 1'b0;
		else
			Q <= D;
	 end

endmodule
