module register16(Q, D, clk, w_en);
  input signed [15:0] D;
  input signed clk, w_en;
  output signed [15:0] Q;
  
  
  wire [15:0] muxout;
  
  mux2to1 m0(Q[0], D[0], w_en, muxout[0]);
  mux2to1 m1(Q[1], D[1], w_en, muxout[1]);
  mux2to1 m2(Q[2], D[2], w_en, muxout[2]);
  mux2to1 m3(Q[3], D[3], w_en, muxout[3]);
  mux2to1 m4(Q[4], D[4], w_en, muxout[4]);
  mux2to1 m5(Q[5], D[5], w_en, muxout[5]);
  mux2to1 m6(Q[6], D[6], w_en, muxout[6]);
  mux2to1 m7(Q[7], D[7], w_en, muxout[7]);
  mux2to1 m8(Q[8], D[8], w_en, muxout[8]);
  mux2to1 m9(Q[9], D[9], w_en, muxout[9]);
  mux2to1 m10(Q[10], D[10], w_en, muxout[10]);
  mux2to1 m11(Q[11], D[11], w_en, muxout[11]);
  mux2to1 m12(Q[12], D[12], w_en, muxout[12]);
  mux2to1 m13(Q[13], D[13], w_en, muxout[13]);
  mux2to1 m14(Q[14], D[14], w_en, muxout[14]);
  mux2to1 m15(Q[15], D[15], w_en, muxout[15]);
  
  d_flipflop dff0(Q[0], muxout[0], clk);
  d_flipflop dff1(Q[1], muxout[1], clk);
  d_flipflop dff2(Q[2], muxout[2], clk);
  d_flipflop dff3(Q[3], muxout[3], clk);
  d_flipflop dff4(Q[4], muxout[4], clk);
  d_flipflop dff5(Q[5], muxout[5], clk);
  d_flipflop dff6(Q[6], muxout[6], clk);
  d_flipflop dff7(Q[7], muxout[7], clk);  
  d_flipflop dff8(Q[8], muxout[8], clk);
  d_flipflop dff9(Q[9], muxout[9], clk);
  d_flipflop dff10(Q[10], muxout[10], clk);
  d_flipflop dff11(Q[11], muxout[11], clk);  
  d_flipflop dff12(Q[12], muxout[12], clk);
  d_flipflop dff13(Q[13], muxout[13], clk);
  d_flipflop dff14(Q[14], muxout[14], clk);
  d_flipflop dff15(Q[15], muxout[15], clk);
  
  
endmodule
