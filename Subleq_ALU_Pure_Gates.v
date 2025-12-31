module Subleq_ALU_Pure_Gates (
    input  [15:0] A,
    input  [15:0] B,
    output [15:0] out_B,
    output        branch_sig
);
    wire [15:0] not_A;
    wire [15:0] diff;
    wire c_out_unused;
    wire vcc; 

    xnor (vcc, A[0], A[0]); 

    // ۱. تولید مکمل یک A با گیت NOT
    not n0(not_A[0], A[0]);   not n1(not_A[1], A[1]);
    not n2(not_A[2], A[2]);   not n3(not_A[3], A[3]);
    not n4(not_A[4], A[4]);   not n5(not_A[5], A[5]);
    not n6(not_A[6], A[6]);   not n7(not_A[7], A[7]);
    not n8(not_A[8], A[8]);   not n9(not_A[9], A[9]);
    not n10(not_A[10], A[10]); not n11(not_A[11], A[11]);
    not n12(not_A[12], A[12]); not n13(not_A[13], A[13]);
    not n14(not_A[14], A[14]); not n15(not_A[15], A[15]);

    // ۲. تفریق با استفاده از ماژول FullAdder16 شما
    fulladder16 subtractor_inst (
        .A(B),
        .B(not_A),
        .c_in(vcc), // استفاده از vcc تولید شده توسط گیت
        .sum(diff),
        .c_out(c_out_unused)
    );

    // ۳. اتصال خروجی به out_B با گیت AND
    and a0(out_B[0], diff[0], vcc);   and a1(out_B[1], diff[1], vcc);
    and a2(out_B[2], diff[2], vcc);   and a3(out_B[3], diff[3], vcc);
    and a4(out_B[4], diff[4], vcc);   and a5(out_B[5], diff[5], vcc);
    and a6(out_B[6], diff[6], vcc);   and a7(out_B[7], diff[7], vcc);
    and a8(out_B[8], diff[8], vcc);   and a9(out_B[9], diff[9], vcc);
    and a10(out_B[10], diff[10], vcc); and a11(out_B[11], diff[11], vcc);
    and a12(out_B[12], diff[12], vcc); and a13(out_B[13], diff[13], vcc);
    and a14(out_B[14], diff[14], vcc); and a15(out_B[15], diff[15], vcc);

    // ۴. منطق تشخیص شرط پرش (<= 0)
    wire is_neg, is_zero, or_l, or_h, any_1;
    
    buf (is_neg, diff[15]); // تشخیص منفی

    or (or_l, diff[0], diff[1], diff[2], diff[3], diff[4], diff[5], diff[6], diff[7]);
    or (or_h, diff[8], diff[9], diff[10], diff[11], diff[12], diff[13], diff[14], diff[15]);
    or (any_1, or_l, or_h);
    not (is_zero, any_1); // تشخیص صفر

    or (branch_sig, is_neg, is_zero); // شرط نهایی

endmodule