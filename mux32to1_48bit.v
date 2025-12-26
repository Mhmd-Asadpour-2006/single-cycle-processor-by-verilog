module mux32to1_48bit (
    input  [47:0] D0, input  [47:0] D1, input  [47:0] D2, input  [47:0] D3,
    input  [47:0] D4, input  [47:0] D5, input  [47:0] D6, input  [47:0] D7,
    input  [47:0] D8, input  [47:0] D9, input  [47:0] D10, input  [47:0] D11,
    input  [47:0] D12, input  [47:0] D13, input  [47:0] D14, input  [47:0] D15,
    input  [47:0] D16, input  [47:0] D17, input  [47:0] D18, input  [47:0] D19,
    input  [47:0] D20, input  [47:0] D21, input  [47:0] D22, input  [47:0] D23,
    input  [47:0] D24, input  [47:0] D25, input  [47:0] D26, input  [47:0] D27,
    input  [47:0] D28, input  [47:0] D29, input  [47:0] D30, input  [47:0] D31,
    input  [4:0] S,
    output [47:0] Y
);

    wire [47:0] l1 [15:0]; 
    wire [47:0] l2 [7:0];  
    wire [47:0] l3 [3:0];  
    wire [47:0] l4 [1:0];  

    mux2to1_48bit m10 (D0,  D1,  S[0], l1[0]);
    mux2to1_48bit m11 (D2,  D3,  S[0], l1[1]);
    mux2to1_48bit m12 (D4,  D5,  S[0], l1[2]);
    mux2to1_48bit m13 (D6,  D7,  S[0], l1[3]);
    mux2to1_48bit m14 (D8,  D9,  S[0], l1[4]);
    mux2to1_48bit m15 (D10, D11, S[0], l1[5]);
    mux2to1_48bit m16 (D12, D13, S[0], l1[6]);
    mux2to1_48bit m17 (D14, D15, S[0], l1[7]);
    mux2to1_48bit m18 (D16, D17, S[0], l1[8]);
    mux2to1_48bit m19 (D18, D19, S[0], l1[9]);
    mux2to1_48bit m1A (D20, D21, S[0], l1[10]);
    mux2to1_48bit m1B (D22, D23, S[0], l1[11]);
    mux2to1_48bit m1C (D24, D25, S[0], l1[12]);
    mux2to1_48bit m1D (D26, D27, S[0], l1[13]);
    mux2to1_48bit m1E (D28, D29, S[0], l1[14]);
    mux2to1_48bit m1F (D30, D31, S[0], l1[15]);

    mux2to1_48bit m20 (l1[0],  l1[1],  S[1], l2[0]);
    mux2to1_48bit m21 (l1[2],  l1[3],  S[1], l2[1]);
    mux2to1_48bit m22 (l1[4],  l1[5],  S[1], l2[2]);
    mux2to1_48bit m23 (l1[6],  l1[7],  S[1], l2[3]);
    mux2to1_48bit m24 (l1[8],  l1[9],  S[1], l2[4]);
    mux2to1_48bit m25 (l1[10], l1[11], S[1], l2[5]);
    mux2to1_48bit m26 (l1[12], l1[13], S[1], l2[6]);
    mux2to1_48bit m27 (l1[14], l1[15], S[1], l2[7]);

    mux2to1_48bit m30 (l2[0], l2[1], S[2], l3[0]);
    mux2to1_48bit m31 (l2[2], l2[3], S[2], l3[1]);
    mux2to1_48bit m32 (l2[4], l2[5], S[2], l3[2]);
    mux2to1_48bit m33 (l2[6], l2[7], S[2], l3[3]);

    mux2to1_48bit m40 (l3[0], l3[1], S[3], l4[0]);
    mux2to1_48bit m41 (l3[2], l3[3], S[3], l4[1]);

    mux2to1_48bit m50 (l4[0], l4[1], S[4], Y);

endmodule