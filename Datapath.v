module DataPath(
    input clk,
    input Activate,
    input [47:0] WriteData,
    input [15:0] WriteAddress,
    output Lt,
    output gt
);

    // =============================
    // Internal wires
    // =============================
    wire NegToSel;
    wire branchActive;
    wire wEnablIfActive;

    wire [15:0] Split3ToL;
    wire [15:0] PCOutIns;
    wire [15:0] PCInputIns;
    wire [47:0] InsMemToSpliter;

    wire [15:0] AToDataMem;
    wire [15:0] BToDataMem;

    wire [15:0] subToA;
    wire [15:0] AToSubtractor;
    wire [15:0] BToSubtractor;

    // =============================
    // Combinational logic
    // =============================
    assign branchActive   = ~NegToSel;
    assign wEnablIfActive = Activate & NegToSel;

    assign Lt = NegToSel;
    assign gt = ~NegToSel;

    // =============================
    // PC selection MUX
    // =============================
    mux2to1_16bit MUX2_1 (
        .clk(clk),
        .A(PCOutIns),
        .B(Split3ToL),
        .S(NegToSel),
        .Y(PCInputIns)
    );

    // =============================
    // Subtractor
    // =============================
    subtractor subb (
        .clk(clk),
        .A(AToSubtractor),
        .B(BToSubtractor),
        .res(subToA),
        .NEG(NegToSel)
    );

    // =============================
    // Program Counter
    // =============================
    PC_Unit PCU (
        .clk(clk),
        .L1(PCInputIns),
        .current_pc(PCOutIns)
    );

    // =============================
    // Instruction split
    // =============================
    split48_to_3x16 spllit (
        .clk(clk),
        .in48(InsMemToSpliter),
        .out16_0(AToDataMem),
        .out16_1(BToDataMem),
        .out16_2(Split3ToL)
    );

    // =============================
    // Instruction Memory
    // =============================
    instruction_memory insMem (
        .clk(clk),
        .readAddress1(PCOutIns),
        .writeAddress(WriteAddress),
        .writeData(WriteData),
        .writeEnable(wEnablIfActive),
        .registerData1(InsMemToSpliter)
    );

    // =============================
    // Data Memory
    // =============================
    data_memory DataMem (
        .clk(clk),
        .readAddress1(AToDataMem),
        .readAddress2(BToDataMem),
        .writeAddress(AToDataMem),
        .writeData(subToA),
        .writeEnable(branchActive),
        .registerData1(AToSubtractor),
        .registerData2(BToSubtractor)
    );

endmodule
