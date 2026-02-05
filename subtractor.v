module subtractor(A,B,res,NEG);
  input signed [15:0] A, B;
  output signed [15:0] res;
  output signed NEG;
  
  wire [15:0] B_inverse;  
  
  not(B_inverse[0],B[0]);
  not(B_inverse[1],B[1]);
  not(B_inverse[2],B[2]);
  not(B_inverse[3],B[3]);
  not(B_inverse[4],B[4]);
  not(B_inverse[5],B[5]);
  not(B_inverse[6],B[6]);
  not(B_inverse[7],B[7]);
  not(B_inverse[8],B[8]);
  not(B_inverse[9],B[9]);
  not(B_inverse[10],B[10]);
  not(B_inverse[11],B[11]);
  not(B_inverse[12],B[12]);
  not(B_inverse[13],B[13]);
  not(B_inverse[14],B[14]);
  not(B_inverse[15],B[15]);
  
  wire signed c_out;
  
  fulladder16 fulladder(A, B_inverse, 1'b1, c_out, res);
  
  buf(NEG,res[15]);

endmodule
