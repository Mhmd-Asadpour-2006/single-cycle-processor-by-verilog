module DataPath(
    input clk,
    input load,
    input [47:0] WriteDataInst,
    input [15:0] WriteAddressInst,
    input [15:0] WriteData,
    input [15:0] WriteAddress,
    output [15:0] B
);

    wire not_load;
    wire branch;
    reg  branch_r;

    wire [15:0] PCOutIns;
    wire [47:0] InsMemToSpliter;

    wire [15:0] AToDataMem;
    wire [15:0] BToDataMem;
    wire [15:0] Split3ToL;

    wire [15:0] subToB;
    wire [15:0] AToSubtractor;
    wire [15:0] BToSubtractor;

    wire [15:0] DataToDataMem;
    wire [15:0] AddressToDataMem;

    wire  cOutAdder;
    wire [15:0] pcAddOne;

    wire [15:0] PCInputIns;
    reg  [15:0] PCInputIns_reg;

    not(not_load, load);

    // PC
    PC_Unit PCU (
        .clk(clk),
        .L1(PCInputIns),
        .WE(not_load),          // وقتی load=1، PC ثابت می‌ماند
        .current_pc(PCOutIns)
    );

    // PC+1
    fulladder16 adder(
        .A(PCOutIns),
        .B(16'b1),
        .c_in(1'b0),
        .c_out(cOutAdder),
        .sum(pcAddOne)
    );

    // Instruction Memory
    instruction_memory insMem (
        .clk(clk),
        .readAddress1(PCOutIns),
        .writeAddress(WriteAddressInst),
        .writeData(WriteDataInst),
        .writeEnable(load),
        .registerData1(InsMemToSpliter)
    );

    // Split instruction into 3x16
    split48_to_3x16 spllit (
        .in48(InsMemToSpliter),
        .out16_0(Split3ToL),
        .out16_1(BToDataMem),
        .out16_2(AToDataMem)
    );

    // هنگام load=1: دیتا مموری را با WriteData/WriteAddress مقداردهی کن
    // هنگام load=0: این مسیرها استفاده نمی‌شوند (چون writeEnable=0)
    mux2to1_16bit mux2_1_two(
        .A(subToB),
        .B(WriteData),
        .S(load),
        .Y(DataToDataMem)
    );

    mux2to1_16bit mux2_1_three(
        .A(BToDataMem),
        .B(WriteAddress),
        .S(load),
        .Y(AddressToDataMem)
    );

    // *** FIX اصلی: writeEnable دیگر همیشه 1 نیست ***
    // فقط هنگام load=1 می‌نویسیم تا حافظه در حالت اجرا خراب نشود
    data_memory DataMem (
        .clk(clk),
        .readAddress1(AToDataMem),
        .readAddress2(BToDataMem),
        .writeAddress(AddressToDataMem),
        .writeData(DataToDataMem),
        .writeEnable(load),          // <<< اصلاح شد
        .registerData1(AToSubtractor),
        .registerData2(BToSubtractor)
    );

    subtractor sub(
        .A(BToSubtractor),
        .B(AToSubtractor),
        .res(subToB),
        .NEG(branch)
    );

    // branch یک سیکل رجیستر می‌شود
    always @(posedge clk)
        branch_r <= branch;

    // انتخاب PC بعدی
    always @(*) begin
        if (branch_r == 1'b1)
            PCInputIns_reg = Split3ToL;
        else
            PCInputIns_reg = pcAddOne;
    end

    assign PCInputIns = PCInputIns_reg;
    assign B = subToB;

endmodule
