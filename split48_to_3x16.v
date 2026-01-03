module split48_to_3x16 (
    input  wire [47:0] in48,
    output wire [15:0] out16_0,
    output wire [15:0] out16_1,
    output wire [15:0] out16_2
);


    buf (out16_0[0],  in48[0]);
    buf (out16_0[1],  in48[1]);
    buf (out16_0[2],  in48[2]);
    buf (out16_0[3],  in48[3]);
    buf (out16_0[4],  in48[4]);
    buf (out16_0[5],  in48[5]);
    buf (out16_0[6],  in48[6]);
    buf (out16_0[7],  in48[7]);
    buf (out16_0[8],  in48[8]);
    buf (out16_0[9],  in48[9]);
    buf (out16_0[10], in48[10]);
    buf (out16_0[11], in48[11]);
    buf (out16_0[12], in48[12]);
    buf (out16_0[13], in48[13]);
    buf (out16_0[14], in48[14]);
    buf (out16_0[15], in48[15]);


    buf (out16_1[0],  in48[16]);
    buf (out16_1[1],  in48[17]);
    buf (out16_1[2],  in48[18]);
    buf (out16_1[3],  in48[19]);
    buf (out16_1[4],  in48[20]);
    buf (out16_1[5],  in48[21]);
    buf (out16_1[6],  in48[22]);
    buf (out16_1[7],  in48[23]);
    buf (out16_1[8],  in48[24]);
    buf (out16_1[9],  in48[25]);
    buf (out16_1[10], in48[26]);
    buf (out16_1[11], in48[27]);
    buf (out16_1[12], in48[28]);
    buf (out16_1[13], in48[29]);
    buf (out16_1[14], in48[30]);
    buf (out16_1[15], in48[31]);


    buf (out16_2[0],  in48[32]);
    buf (out16_2[1],  in48[33]);
    buf (out16_2[2],  in48[34]);
    buf (out16_2[3],  in48[35]);
    buf (out16_2[4],  in48[36]);
    buf (out16_2[5],  in48[37]);
    buf (out16_2[6],  in48[38]);
    buf (out16_2[7],  in48[39]);
    buf (out16_2[8],  in48[40]);
    buf (out16_2[9],  in48[41]);
    buf (out16_2[10], in48[42]);
    buf (out16_2[11], in48[43]);
    buf (out16_2[12], in48[44]);
    buf (out16_2[13], in48[45]);
    buf (out16_2[14], in48[46]);
    buf (out16_2[15], in48[47]);

endmodule
