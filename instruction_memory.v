module instruction_memory(
    input [15:0] readAddress1,
    input [15:0] writeAddress,
    input [47:0] writeData,
    input clk,
    input writeEnable,
    output [47:0] registerData1,
);

    wire [31:0] writeSelect;
    wire [47:0] r0_out, r1_out, r2_out, r3_out, r4_out, r5_out, r6_out, r7_out;
    wire [47:0] r8_out, r9_out, r10_out, r11_out, r12_out, r13_out, r14_out, r15_out;
    wire [47:0] r16_out, r17_out, r18_out, r19_out, r20_out, r21_out, r22_out, r23_out;
    wire [47:0] r24_out, r25_out, r26_out, r27_out, r28_out, r29_out, r30_out, r31_out;

    decoder5to32 dec0 (writeAddress[4:0], writeEnable, writeSelect);

    register48 r0  (r0_out,  writeData, clk, writeSelect[0]);
    register48 r1  (r1_out,  writeData, clk, writeSelect[1]);
    register48 r2  (r2_out,  writeData, clk, writeSelect[2]);
    register48 r3  (r3_out,  writeData, clk, writeSelect[3]);
    register48 r4  (r4_out,  writeData, clk, writeSelect[4]);
    register48 r5  (r5_out,  writeData, clk, writeSelect[5]);
    register48 r6  (r6_out,  writeData, clk, writeSelect[6]);
    register48 r7  (r7_out,  writeData, clk, writeSelect[7]);
    register48 r8  (r8_out,  writeData, clk, writeSelect[8]);
    register48 r9  (r9_out,  writeData, clk, writeSelect[9]);
    register48 r10 (r10_out, writeData, clk, writeSelect[10]);
    register48 r11 (r11_out, writeData, clk, writeSelect[11]);
    register48 r12 (r12_out, writeData, clk, writeSelect[12]);
    register48 r13 (r13_out, writeData, clk, writeSelect[13]);
    register48 r14 (r14_out, writeData, clk, writeSelect[14]);
    register48 r15 (r15_out, writeData, clk, writeSelect[15]);
    register48 r16 (r16_out, writeData, clk, writeSelect[16]);
    register48 r17 (r17_out, writeData, clk, writeSelect[17]);
    register48 r18 (r18_out, writeData, clk, writeSelect[18]);
    register48 r19 (r19_out, writeData, clk, writeSelect[19]);
    register48 r20 (r20_out, writeData, clk, writeSelect[20]);
    register48 r21 (r21_out, writeData, clk, writeSelect[21]);
    register48 r22 (r22_out, writeData, clk, writeSelect[22]);
    register48 r23 (r23_out, writeData, clk, writeSelect[23]);
    register48 r24 (r24_out, writeData, clk, writeSelect[24]);
    register48 r25 (r25_out, writeData, clk, writeSelect[25]);
    register48 r26 (r26_out, writeData, clk, writeSelect[26]);
    register48 r27 (r27_out, writeData, clk, writeSelect[27]);
    register48 r28 (r28_out, writeData, clk, writeSelect[28]);
    register48 r29 (r29_out, writeData, clk, writeSelect[29]);
    register48 r30 (r30_out, writeData, clk, writeSelect[30]);
    register48 r31 (r31_out, writeData, clk, writeSelect[31]);

    mux32to1_48bit mux_r1 (
        r0_out, r1_out, r2_out, r3_out, r4_out, r5_out, r6_out, r7_out,
        r8_out, r9_out, r10_out, r11_out, r12_out, r13_out, r14_out, r15_out,
        r16_out, r17_out, r18_out, r19_out, r20_out, r21_out, r22_out, r23_out,
        r24_out, r25_out, r26_out, r27_out, r28_out, r29_out, r30_out, r31_out,
        readAddress1[4:0], registerData1
    );


endmodule