module mux2to1_48bit (
    input  [47:0] A,
    input  [47:0] B,
    input         S,
    output [47:0] Y
);

    wire nS;
    not (nS, S);

    wire a0, b0;
    and (a0, A[0], nS);
    and (b0, B[0], S);
    or  (Y[0], a0, b0);

    wire a1, b1;
    and (a1, A[1], nS);
    and (b1, B[1], S);
    or  (Y[1], a1, b1);

    wire a2, b2;
    and (a2, A[2], nS);
    and (b2, B[2], S);
    or  (Y[2], a2, b2);

    wire a3, b3;
    and (a3, A[3], nS);
    and (b3, B[3], S);
    or  (Y[3], a3, b3);

    wire a4, b4;
    and (a4, A[4], nS);
    and (b4, B[4], S);
    or  (Y[4], a4, b4);

    wire a5, b5;
    and (a5, A[5], nS);
    and (b5, B[5], S);
    or  (Y[5], a5, b5);

    wire a6, b6;
    and (a6, A[6], nS);
    and (b6, B[6], S);
    or  (Y[6], a6, b6);

    wire a7, b7;
    and (a7, A[7], nS);
    and (b7, B[7], S);
    or  (Y[7], a7, b7);

    wire a8, b8;
    and (a8, A[8], nS);
    and (b8, B[8], S);
    or  (Y[8], a8, b8);

    wire a9, b9;
    and (a9, A[9], nS);
    and (b9, B[9], S);
    or  (Y[9], a9, b9);

    wire a10, b10;
    and (a10, A[10], nS);
    and (b10, B[10], S);
    or  (Y[10], a10, b10);

    wire a11, b11;
    and (a11, A[11], nS);
    and (b11, B[11], S);
    or  (Y[11], a11, b11);

    wire a12, b12;
    and (a12, A[12], nS);
    and (b12, B[12], S);
    or  (Y[12], a12, b12);

    wire a13, b13;
    and (a13, A[13], nS);
    and (b13, B[13], S);
    or  (Y[13], a13, b13);

    wire a14, b14;
    and (a14, A[14], nS);
    and (b14, B[14], S);
    or  (Y[14], a14, b14);

    wire a15, b15;
    and (a15, A[15], nS);
    and (b15, B[15], S);
    or  (Y[15], a15, b15);

    wire a16, b16;
    and (a16, A[16], nS);
    and (b16, B[16], S);
    or  (Y[16], a16, b16);

    wire a17, b17;
    and (a17, A[17], nS);
    and (b17, B[17], S);
    or  (Y[17], a17, b17);

    wire a18, b18;
    and (a18, A[18], nS);
    and (b18, B[18], S);
    or  (Y[18], a18, b18);

    wire a19, b19;
    and (a19, A[19], nS);
    and (b19, B[19], S);
    or  (Y[19], a19, b19);

    wire a20, b20;
    and (a20, A[20], nS);
    and (b20, B[20], S);
    or  (Y[20], a20, b20);

    wire a21, b21;
    and (a21, A[21], nS);
    and (b21, B[21], S);
    or  (Y[21], a21, b21);

    wire a22, b22;
    and (a22, A[22], nS);
    and (b22, B[22], S);
    or  (Y[22], a22, b22);

    wire a23, b23;
    and (a23, A[23], nS);
    and (b23, B[23], S);
    or  (Y[23], a23, b23);

    wire a24, b24;
    and (a24, A[24], nS);
    and (b24, B[24], S);
    or  (Y[24], a24, b24);

    wire a25, b25;
    and (a25, A[25], nS);
    and (b25, B[25], S);
    or  (Y[25], a25, b25);

    wire a26, b26;
    and (a26, A[26], nS);
    and (b26, B[26], S);
    or  (Y[26], a26, b26);

    wire a27, b27;
    and (a27, A[27], nS);
    and (b27, B[27], S);
    or  (Y[27], a27, b27);

    wire a28, b28;
    and (a28, A[28], nS);
    and (b28, B[28], S);
    or  (Y[28], a28, b28);

    wire a29, b29;
    and (a29, A[29], nS);
    and (b29, B[29], S);
    or  (Y[29], a29, b29);

    wire a30, b30;
    and (a30, A[30], nS);
    and (b30, B[30], S);
    or  (Y[30], a30, b30);

    wire a31, b31;
    and (a31, A[31], nS);
    and (b31, B[31], S);
    or  (Y[31], a31, b31);

    wire a32, b32;
    and (a32, A[32], nS);
    and (b32, B[32], S);
    or  (Y[32], a32, b32);

    wire a33, b33;
    and (a33, A[33], nS);
    and (b33, B[33], S);
    or  (Y[33], a33, b33);

    wire a34, b34;
    and (a34, A[34], nS);
    and (b34, B[34], S);
    or  (Y[34], a34, b34);

    wire a35, b35;
    and (a35, A[35], nS);
    and (b35, B[35], S);
    or  (Y[35], a35, b35);

    wire a36, b36;
    and (a36, A[36], nS);
    and (b36, B[36], S);
    or  (Y[36], a36, b36);

    wire a37, b37;
    and (a37, A[37], nS);
    and (b37, B[37], S);
    or  (Y[37], a37, b37);

    wire a38, b38;
    and (a38, A[38], nS);
    and (b38, B[38], S);
    or  (Y[38], a38, b38);

    wire a39, b39;
    and (a39, A[39], nS);
    and (b39, B[39], S);
    or  (Y[39], a39, b39);

    wire a40, b40;
    and (a40, A[40], nS);
    and (b40, B[40], S);
    or  (Y[40], a40, b40);

    wire a41, b41;
    and (a41, A[41], nS);
    and (b41, B[41], S);
    or  (Y[41], a41, b41);

    wire a42, b42;
    and (a42, A[42], nS);
    and (b42, B[42], S);
    or  (Y[42], a42, b42);

    wire a43, b43;
    and (a43, A[43], nS);
    and (b43, B[43], S);
    or  (Y[43], a43, b43);

    wire a44, b44;
    and (a44, A[44], nS);
    and (b44, B[44], S);
    or  (Y[44], a44, b44);

    wire a45, b45;
    and (a45, A[45], nS);
    and (b45, B[45], S);
    or  (Y[45], a45, b45);

    wire a46, b46;
    and (a46, A[46], nS);
    and (b46, B[46], S);
    or  (Y[46], a46, b46);

    wire a47, b47;
    and (a47, A[47], nS);
    and (b47, B[47], S);
    or  (Y[47], a47, b47);

endmodule