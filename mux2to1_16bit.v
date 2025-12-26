module mux2to1_16bit (
    input  [15:0] A,
    input  [15:0] B,
    input         S,
    output [15:0] Y
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

endmodule
