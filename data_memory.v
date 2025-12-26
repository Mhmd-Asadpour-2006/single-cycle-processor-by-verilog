module data_memory(
    input [15:0] readAddress1,
    input [15:0] readAddress2,
    input [15:0] writeAddress,
    input [15:0] writeData,
    input clk,
    input writeEnable,
    output [15:0] registerData1,
    output [15:0] registerData2
);

    wire [31:0] writeSelect;
    wire [15:0] r0_out, r1_out, r2_out, r3_out, r4_out, r5_out, r6_out, r7_out;
    wire [15:0] r8_out, r9_out, r10_out, r11_out, r12_out, r13_out, r14_out, r15_out;
    wire [15:0] r16_out, r17_out, r18_out, r19_out, r20_out, r21_out, r22_out, r23_out;
    wire [15:0] r24_out, r25_out, r26_out, r27_out, r28_out, r29_out, r30_out, r31_out;

    decoder5to32 dec0 (writeAddress[4:0], writeEnable, writeSelect);

    register16 r0  (r0_out,  writeData, clk, writeSelect[0]);
    register16 r1  (r1_out,  writeData, clk, writeSelect[1]);
    register16 r2  (r2_out,  writeData, clk, writeSelect[2]);
    register16 r3  (r3_out,  writeData, clk, writeSelect[3]);
    register16 r4  (r4_out,  writeData, clk, writeSelect[4]);
    register16 r5  (r5_out,  writeData, clk, writeSelect[5]);
    register16 r6  (r6_out,  writeData, clk, writeSelect[6]);
    register16 r7  (r7_out,  writeData, clk, writeSelect[7]);
    register16 r8  (r8_out,  writeData, clk, writeSelect[8]);
    register16 r9  (r9_out,  writeData, clk, writeSelect[9]);
    register16 r10 (r10_out, writeData, clk, writeSelect[10]);
    register16 r11 (r11_out, writeData, clk, writeSelect[11]);
    register16 r12 (r12_out, writeData, clk, writeSelect[12]);
    register16 r13 (r13_out, writeData, clk, writeSelect[13]);
    register16 r14 (r14_out, writeData, clk, writeSelect[14]);
    register16 r15 (r15_out, writeData, clk, writeSelect[15]);
    register16 r16 (r16_out, writeData, clk, writeSelect[16]);
    register16 r17 (r17_out, writeData, clk, writeSelect[17]);
    register16 r18 (r18_out, writeData, clk, writeSelect[18]);
    register16 r19 (r19_out, writeData, clk, writeSelect[19]);
    register16 r20 (r20_out, writeData, clk, writeSelect[20]);
    register16 r21 (r21_out, writeData, clk, writeSelect[21]);
    register16 r22 (r22_out, writeData, clk, writeSelect[22]);
    register16 r23 (r23_out, writeData, clk, writeSelect[23]);
    register16 r24 (r24_out, writeData, clk, writeSelect[24]);
    register16 r25 (r25_out, writeData, clk, writeSelect[25]);
    register16 r26 (r26_out, writeData, clk, writeSelect[26]);
    register16 r27 (r27_out, writeData, clk, writeSelect[27]);
    register16 r28 (r28_out, writeData, clk, writeSelect[28]);
    register16 r29 (r29_out, writeData, clk, writeSelect[29]);
    register16 r30 (r30_out, writeData, clk, writeSelect[30]);
    register16 r31 (r31_out, writeData, clk, writeSelect[31]);

    mux32to1_16bit mux_r1 (
        r0_out, r1_out, r2_out, r3_out, r4_out, r5_out, r6_out, r7_out,
        r8_out, r9_out, r10_out, r11_out, r12_out, r13_out, r14_out, r15_out,
        r16_out, r17_out, r18_out, r19_out, r20_out, r21_out, r22_out, r23_out,
        r24_out, r25_out, r26_out, r27_out, r28_out, r29_out, r30_out, r31_out,
        readAddress1[4:0], registerData1
    );

    mux32to1_16bit mux_r2 (
        r0_out, r1_out, r2_out, r3_out, r4_out, r5_out, r6_out, r7_out,
        r8_out, r9_out, r10_out, r11_out, r12_out, r13_out, r14_out, r15_out,
        r16_out, r17_out, r18_out, r19_out, r20_out, r21_out, r22_out, r23_out,
        r24_out, r25_out, r26_out, r27_out, r28_out, r29_out, r30_out, r31_out,
        readAddress2[4:0], registerData2
    );
	 

endmodule
