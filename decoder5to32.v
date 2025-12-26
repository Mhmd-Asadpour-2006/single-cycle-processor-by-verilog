module decoder5to32(
    input  [4:0] D,
    input        EN,
    output [31:0] Q
);

    wire n0, n1, n2, n3, n4;

    not(n0, D[0]);
    not(n1, D[1]);
    not(n2, D[2]);
    not(n3, D[3]);
    not(n4, D[4]);

    and(Q[0],  EN, n4, n3, n2, n1, n0);
    and(Q[1],  EN, n4, n3, n2, n1, D[0]);
    and(Q[2],  EN, n4, n3, n2, D[1], n0);
    and(Q[3],  EN, n4, n3, n2, D[1], D[0]);
    and(Q[4],  EN, n4, n3, D[2], n1, n0);
    and(Q[5],  EN, n4, n3, D[2], n1, D[0]);
    and(Q[6],  EN, n4, n3, D[2], D[1], n0);
    and(Q[7],  EN, n4, n3, D[2], D[1], D[0]);

    and(Q[8],  EN, n4, D[3], n2, n1, n0);
    and(Q[9],  EN, n4, D[3], n2, n1, D[0]);
    and(Q[10], EN, n4, D[3], n2, D[1], n0);
    and(Q[11], EN, n4, D[3], n2, D[1], D[0]);
    and(Q[12], EN, n4, D[3], D[2], n1, n0);
    and(Q[13], EN, n4, D[3], D[2], n1, D[0]);
    and(Q[14], EN, n4, D[3], D[2], D[1], n0);
    and(Q[15], EN, n4, D[3], D[2], D[1], D[0]);

    and(Q[16], EN, D[4], n3, n2, n1, n0);
    and(Q[17], EN, D[4], n3, n2, n1, D[0]);
    and(Q[18], EN, D[4], n3, n2, D[1], n0);
    and(Q[19], EN, D[4], n3, n2, D[1], D[0]);
    and(Q[20], EN, D[4], n3, D[2], n1, n0);
    and(Q[21], EN, D[4], n3, D[2], n1, D[0]);
    and(Q[22], EN, D[4], n3, D[2], D[1], n0);
    and(Q[23], EN, D[4], n3, D[2], D[1], D[0]);

    and(Q[24], EN, D[4], D[3], n2, n1, n0);
    and(Q[25], EN, D[4], D[3], n2, n1, D[0]);
    and(Q[26], EN, D[4], D[3], n2, D[1], n0);
    and(Q[27], EN, D[4], D[3], n2, D[1], D[0]);
    and(Q[28], EN, D[4], D[3], D[2], n1, n0);
    and(Q[29], EN, D[4], D[3], D[2], n1, D[0]);
    and(Q[30], EN, D[4], D[3], D[2], D[1], n0);
    and(Q[31], EN, D[4], D[3], D[2], D[1], D[0]);

endmodule
