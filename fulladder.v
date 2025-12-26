module fulladder(sum, c_out, a, b, c_in);
output sum, c_out;
input a, b, c_in;

  wire s1, c1, s2;
  xor xor0(s1, a, b);
  and and0(c1, a, b);
  xor xor1(sum, s1, c_in);
  and and1(s2, s1, c_in);
  or or1(c_out, s2, c1);
  
endmodule