module mux2to1(A,B,sel,out);
	input A,B,sel;
	output out;
	
	wire andA , andB,notsel;
	not(notsel,sel);
	and(andA,A,notsel);
	and(andB,B,sel);
	
	or(out,andA,andB);
	
endmodule

