module fulladder16 (A, B, c_in, c_out, sum);

input  [15:0] A, B;
input         c_in;
output        c_out;
output [15:0] sum;

wire [15:0] c;

fulladder f0  (sum[0],  c[0],  A[0],  B[0],  c_in);
fulladder f1  (sum[1],  c[1],  A[1],  B[1],  c[0]);
fulladder f2  (sum[2],  c[2],  A[2],  B[2],  c[1]);
fulladder f3  (sum[3],  c[3],  A[3],  B[3],  c[2]);
fulladder f4  (sum[4],  c[4],  A[4],  B[4],  c[3]);
fulladder f5  (sum[5],  c[5],  A[5],  B[5],  c[4]);
fulladder f6  (sum[6],  c[6],  A[6],  B[6],  c[5]);
fulladder f7  (sum[7],  c[7],  A[7],  B[7],  c[6]);
fulladder f8  (sum[8],  c[8],  A[8],  B[8],  c[7]);
fulladder f9  (sum[9],  c[9],  A[9],  B[9],  c[8]);
fulladder f10 (sum[10], c[10], A[10], B[10], c[9]);
fulladder f11 (sum[11], c[11], A[11], B[11], c[10]);
fulladder f12 (sum[12], c[12], A[12], B[12], c[11]);
fulladder f13 (sum[13], c[13], A[13], B[13], c[12]);
fulladder f14 (sum[14], c[14], A[14], B[14], c[13]);
fulladder f15 (sum[15], c[15], A[15], B[15], c[14]);

buf (c_out, c[15]);

endmodule

