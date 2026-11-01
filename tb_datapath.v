`timescale 1ns/1ps
module tb_datapath;
  reg clk=0; always #5 clk=~clk;
  reg load=0; reg [47:0] WDI=0; reg [15:0] WAI=0, WD=0, WA=0; wire [15:0] B;
  DataPath dut(.clk(clk),.load(load),.WriteDataInst(WDI),.WriteAddressInst(WAI),.WriteData(WD),.WriteAddress(WA),.B(B));
  wire [511:0] dm = { dut.DataMem.r31_out, dut.DataMem.r30_out, dut.DataMem.r29_out, dut.DataMem.r28_out, dut.DataMem.r27_out, dut.DataMem.r26_out, dut.DataMem.r25_out, dut.DataMem.r24_out, dut.DataMem.r23_out, dut.DataMem.r22_out, dut.DataMem.r21_out, dut.DataMem.r20_out, dut.DataMem.r19_out, dut.DataMem.r18_out, dut.DataMem.r17_out, dut.DataMem.r16_out, dut.DataMem.r15_out, dut.DataMem.r14_out, dut.DataMem.r13_out, dut.DataMem.r12_out, dut.DataMem.r11_out, dut.DataMem.r10_out, dut.DataMem.r9_out, dut.DataMem.r8_out, dut.DataMem.r7_out, dut.DataMem.r6_out, dut.DataMem.r5_out, dut.DataMem.r4_out, dut.DataMem.r3_out, dut.DataMem.r2_out, dut.DataMem.r1_out, dut.DataMem.r0_out };
  reg [47:0] prog[0:31]; reg [15:0] im[0:31], rm[0:31]; reg [15:0] rpc; integer i,c,k,err;
  function [47:0] I; input [15:0] a,b,l; I={a,b,l}; endfunction
  initial begin
    err=0;
    for(i=0;i<32;i=i+1) begin prog[i]=I(0,0,10); im[i]=0; end
    im[1]=5; im[2]=3; im[4]=1; im[7]=100; im[8]=100;
    prog[0]=I(2,1,31); prog[1]=I(2,1,5); prog[2]=I(4,7,31); prog[5]=I(4,3,9);
    prog[6]=I(4,8,31); prog[9]=I(0,0,31); prog[10]=I(4,9,10);
    for(i=0;i<32;i=i+1) begin @(negedge clk); load=1; WAI=i; WDI=prog[i]; WA=i; WD=im[i]; end
    @(negedge clk); load=0; WAI=0; WDI=0; WA=0; WD=0;   // run starts here, no reset needed
    for(i=0;i<32;i=i+1) rm[i]=im[i]; rpc=0;
    for(c=0;c<40;c=c+1) begin
      @(posedge clk);
      begin : step reg [47:0] n; reg [15:0] a,b,l,v; n=prog[rpc[4:0]]; a=n[47:32]; b=n[31:16]; l=n[15:0];
        v=rm[b[4:0]]-rm[a[4:0]]; rm[b[4:0]]=v; rpc=v[15]?l:rpc+1; end
      #1;
      for(k=0;k<32;k=k+1) if(dm[k*16+:16]!==rm[k]) begin err=err+1; $display("cyc %0d mem[%0d] dut=%0d ref=%0d",c,k,$signed(dm[k*16+:16]),$signed(rm[k])); end
      if(dut.PCOutIns!==rpc) begin err=err+1; $display("cyc %0d PC dut=%0d ref=%0d",c,dut.PCOutIns,rpc); end
    end
    if (err==0) $display("PASS: DataPath matches SUBLEQ reference for 40 cycles"); else $display("FAIL: %0d mismatches", err);
    $finish;
  end
endmodule
