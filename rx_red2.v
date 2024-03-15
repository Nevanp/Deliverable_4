module rx_red2(
          input clk,
          input clk_en,
          input sym_clk,
		input reset,
		   input signed [17:0] x_in,
		   output reg signed [17:0] y   );
			
/*
reg signed [17:0] b0, b1, b2, b3, b4, b5, b6, b7,
                  b8, b9, b10, b11, b12, b13, b14, b15;
reg signed [17:0] x0, x1, x2, x3, x4, x5, x6, x7, x8, x9,
                  x10, x11, x12, x13, x14, x15, x16, x17,
						x18, x19, 
						X20, X21, X2, X2, X2, X2, X2, 
						X2, X2, X2, 
*/
integer i;	
reg signed [17:0]	b[64:0];				 
reg signed [17:0]	x[128:0];	
reg signed [35:0] mult_out;
reg signed [17:0] sum_level_0[64:0];
reg signed [17:0] sum_level_1[64:0];
reg signed [35:0] sum_level_5;

always @ (posedge clk)
if(clk_en)
x[0] <= {x_in[17],x_in[17:1]};
else
x[0] <= x[0];

always @ (posedge clk)
if(clk_en)
for(i=1; i<129;i=i+1)
x[i] <= x[i-1];
else
for(i=1; i<129;i=i+1)
x[i] <= x[i];


always @ *
for(i=0;i<=63;i=i+1)
sum_level_0[i] <= x[i]+x[128-i];

always @ *
sum_level_0[64] <= x[64];


always @ (posedge clk)
for(i=0;i<65;i=i+1)
sum_level_1[i] <= sum_level_0[i];

/// Mult Reduction section
reg unsigned [1:0] sam_mult_count,sys_mult_count;

always @ (posedge clk)
if(reset)
sys_mult_count <= 2'b0;
else
sys_mult_count <= sys_mult_count +1'b1;

always @ (posedge clk)
if(reset)
sam_mult_count <= 2'b0;
else //if(clk_en)
sam_mult_count <= sam_mult_count +1'b1;

// mux
reg signed [35:0] mult_1,mult_2,mult_3,mult_4,mult_5,mult_6,mult_7,mult_8,mult_9,mult_10,mult_11,mult_12,mult_13,mult_14,mult_15,mult_16;
reg signed [17:0] sam_out0,sam_out1,sam_out2,sam_out3,sam_out4,sam_out5,sam_out6,sam_out7,sam_out8,sam_out9,sam_out10,sam_out11,sam_out12,sam_out13,sam_out14,sam_out15;
reg signed [17:0] sam_out0a,sam_out1a,sam_out2a,sam_out3a,sam_out4a,sam_out5a,sam_out6a,sam_out7a,sam_out8a,sam_out9a,sam_out10a,sam_out11a,sam_out12a,sam_out13a,sam_out14a,sam_out15a;
reg signed [17:0] b_out0a,b_out1a,b_out2a,b_out3a,b_out4a,b_out5a,b_out6a,b_out7a,b_out8a,b_out9a,b_out10a,b_out11a,b_out12a,b_out13a,b_out14a,b_out15a;
reg signed [17:0] b_out0,b_out1,b_out2,b_out3,b_out4,b_out5,b_out6,b_out7,b_out8,b_out9,b_out10,b_out11,b_out12,b_out13,b_out14,b_out15;
reg signed [17:0] sys_out0,sys_out1,sys_out2,sys_out3;
reg signed [17:0] b_sys_out0,b_sys_out1,b_sys_out2,b_sys_out3;

always @ (*)
begin
case(sam_mult_count)
2'b00: sam_out0<= sum_level_1[0];
2'b01: sam_out0<= sum_level_1[1];
2'b10: sam_out0<= sum_level_1[2];
2'b11: sam_out0<= sum_level_1[3];
endcase
end
always @ (*)
begin
case(sam_mult_count)
2'b00: sam_out1<= sum_level_1[4];
2'b01: sam_out1<= sum_level_1[5];
2'b10: sam_out1<= sum_level_1[6];
2'b11: sam_out1<= sum_level_1[7];
endcase
end
always @ (*)
begin
case(sam_mult_count)
2'b00: sam_out2<= sum_level_1[8];
2'b01: sam_out2<= sum_level_1[9];
2'b10: sam_out2<= sum_level_1[10];
2'b11: sam_out2<= sum_level_1[11];
endcase
end
always @ (*)
begin
case(sam_mult_count)
2'b00: sam_out3<= sum_level_1[12];
2'b01: sam_out3<= sum_level_1[13];
2'b10: sam_out3<= sum_level_1[14];
2'b11: sam_out3<= sum_level_1[15];
endcase
end
always @ (*)
begin
case(sam_mult_count)
2'b00: sam_out4<= sum_level_1[16];
2'b01: sam_out4<= sum_level_1[17];
2'b10: sam_out4<= sum_level_1[18];
2'b11: sam_out4<= sum_level_1[19];
endcase
end
always @ (*)
begin
case(sam_mult_count)
2'b00: sam_out5<= sum_level_1[20];
2'b01: sam_out5<= sum_level_1[21];
2'b10: sam_out5<= sum_level_1[22];
2'b11: sam_out5<= sum_level_1[23];
endcase
end
always @ (*)
begin
case(sam_mult_count)
2'b00: sam_out6<= sum_level_1[24];
2'b01: sam_out6<= sum_level_1[25];
2'b10: sam_out6<= sum_level_1[26];
2'b11: sam_out6<= sum_level_1[27];
endcase
end
always @ (*)
begin
case(sam_mult_count)
2'b00: sam_out7<= sum_level_1[28];
2'b01: sam_out7<= sum_level_1[29];
2'b10: sam_out7<= sum_level_1[30];
2'b11: sam_out7<= sum_level_1[31];
endcase
end
always @ (*)
begin
case(sam_mult_count)
2'b00: sam_out8<= sum_level_1[32];
2'b01: sam_out8<= sum_level_1[33];
2'b10: sam_out8<= sum_level_1[34];
2'b11: sam_out8<= sum_level_1[35];
endcase
end
always @ (*)
begin
case(sam_mult_count)
2'b00: sam_out9<= sum_level_1[36];
2'b01: sam_out9<= sum_level_1[37];
2'b10: sam_out9<= sum_level_1[38];
2'b11: sam_out9<= sum_level_1[39];
endcase
end
always @ (*)
begin
case(sam_mult_count)
2'b00: sam_out10<= sum_level_1[40];
2'b01: sam_out10<= sum_level_1[41];
2'b10: sam_out10<= sum_level_1[42];
2'b11: sam_out10<= sum_level_1[43];
endcase
end
always @ (*)
begin
case(sam_mult_count)
2'b00: sam_out11<= sum_level_1[44];
2'b01: sam_out11<= sum_level_1[45];
2'b10: sam_out11<= sum_level_1[46];
2'b11: sam_out11<= sum_level_1[47];
endcase
end
always @ (*)
begin
case(sam_mult_count)
2'b00: sam_out12<= sum_level_1[48];
2'b01: sam_out12<= sum_level_1[49];
2'b10: sam_out12<= sum_level_1[50];
2'b11: sam_out12<= sum_level_1[51];
endcase
end
always @ (*)
begin
case(sam_mult_count)
2'b00: sam_out13<= sum_level_1[52];
2'b01: sam_out13<= sum_level_1[53];
2'b10: sam_out13<= sum_level_1[54];
2'b11: sam_out13<= sum_level_1[55];
endcase
end
always @ (*)
begin
case(sam_mult_count)
2'b00: sam_out14<= sum_level_1[56];
2'b01: sam_out14<= sum_level_1[57];
2'b10: sam_out14<= sum_level_1[58];
2'b11: sam_out14<= sum_level_1[59];
endcase
end
always @ (*)
begin
case(sam_mult_count)
2'b00: sam_out15<= sum_level_1[60];
2'b01: sam_out15<= sum_level_1[61];
2'b10: sam_out15<= sum_level_1[62];
2'b11: sam_out15<= sum_level_1[63];
endcase
end

always @ (posedge clk)
sam_out0a <= sam_out0;

always @ (posedge clk)
sam_out1a <= sam_out1;

always @ (posedge clk)
sam_out2a <= sam_out2;

always @ (posedge clk)
sam_out3a <= sam_out3;

always @ (posedge clk)
sam_out4a <= sam_out4;

always @ (posedge clk)
sam_out5a <= sam_out5;

always @ (posedge clk)
sam_out6a <= sam_out6;

always @ (posedge clk)
sam_out7a <= sam_out7;

always @ (posedge clk)
sam_out8a <= sam_out8;

always @ (posedge clk)
sam_out9a <= sam_out9;

always @ (posedge clk)
sam_out10a <= sam_out10;

always @ (posedge clk)
sam_out11a <= sam_out11;

always @ (posedge clk)
sam_out12a <= sam_out12;

always @ (posedge clk)
sam_out13a <= sam_out13;

always @ (posedge clk)
sam_out14a <= sam_out14;

always @ (posedge clk)
sam_out15a <= sam_out15;




always @ (*)
begin
case(sam_mult_count)
2'b00: b_out0<= b[0];
2'b01: b_out0<= b[1];
2'b10: b_out0<= b[2];
2'b11: b_out0<= b[3];
endcase
end
 
always @ (*)
begin
case(sam_mult_count)
2'b00: b_out1<= b[4];
2'b01: b_out1<= b[5];
2'b10: b_out1<= b[6];
2'b11: b_out1<= b[7];
endcase
end
 
always @ (*)
begin
case(sam_mult_count)
2'b00: b_out2<= b[8];
2'b01: b_out2<= b[9];
2'b10: b_out2<= b[10];
2'b11: b_out2<= b[11];
endcase
end
 
always @ (*)
begin
case(sam_mult_count)
2'b00: b_out3<= b[12];
2'b01: b_out3<= b[13];
2'b10: b_out3<= b[14];
2'b11: b_out3<= b[15];
endcase
end
 
always @ (*)
begin
case(sam_mult_count)
2'b00: b_out4<= b[16];
2'b01: b_out4<= b[17];
2'b10: b_out4<= b[18];
2'b11: b_out4<= b[19];
endcase
end
 
always @ (*)
begin
case(sam_mult_count)
2'b00: b_out5<= b[20];
2'b01: b_out5<= b[21];
2'b10: b_out5<= b[22];
2'b11: b_out5<= b[23];
endcase
end
 
always @ (*)
begin
case(sam_mult_count)
2'b00: b_out6<= b[24];
2'b01: b_out6<= b[25];
2'b10: b_out6<= b[26];
2'b11: b_out6<= b[27];
endcase
end
 
always @ (*)
begin
case(sam_mult_count)
2'b00: b_out7<= b[28];
2'b01: b_out7<= b[29];
2'b10: b_out7<= b[30];
2'b11: b_out7<= b[31];
endcase
end
 
always @ (*)
begin
case(sam_mult_count)
2'b00: b_out8<= b[32];
2'b01: b_out8<= b[33];
2'b10: b_out8<= b[34];
2'b11: b_out8<= b[35];
endcase
end
 
always @ (*)
begin
case(sam_mult_count)
2'b00: b_out9<= b[36];
2'b01: b_out9<= b[37];
2'b10: b_out9<= b[38];
2'b11: b_out9<= b[39];
endcase
end
 
always @ (*)
begin
case(sam_mult_count)
2'b00: b_out10<= b[40];
2'b01: b_out10<= b[41];
2'b10: b_out10<= b[42];
2'b11: b_out10<= b[43];
endcase
end
 
always @ (*)
begin
case(sam_mult_count)
2'b00: b_out11<= b[44];
2'b01: b_out11<= b[45];
2'b10: b_out11<= b[46];
2'b11: b_out11<= b[47];
endcase
end
 
always @ (*)
begin
case(sam_mult_count)
2'b00: b_out12<= b[48];
2'b01: b_out12<= b[49];
2'b10: b_out12<= b[50];
2'b11: b_out12<= b[51];
endcase
end
 
always @ (*)
begin
case(sam_mult_count)
2'b00: b_out13<= b[52];
2'b01: b_out13<= b[53];
2'b10: b_out13<= b[54];
2'b11: b_out13<= b[55];
endcase
end
 
always @ (*)
begin
case(sam_mult_count)
2'b00: b_out14<= b[56];
2'b01: b_out14<= b[57];
2'b10: b_out14<= b[58];
2'b11: b_out14<= b[59];
endcase
end
 
always @ (*)
begin
case(sam_mult_count)
2'b00: b_out15<= b[60];
2'b01: b_out15<= b[61];
2'b10: b_out15<= b[62];
2'b11: b_out15<= b[63];
endcase
end
 
always @ (posedge clk)
b_out0a <= b_out0;

always @ (posedge clk)
b_out1a <= b_out1;

always @ (posedge clk)
b_out2a <= b_out2;

always @ (posedge clk)
b_out3a <= b_out3;

always @ (posedge clk)
b_out4a <= b_out4;

always @ (posedge clk)
b_out5a <= b_out5;

always @ (posedge clk)
b_out6a <= b_out6;

always @ (posedge clk)
b_out7a <= b_out7;

always @ (posedge clk)
b_out8a <= b_out8;

always @ (posedge clk)
b_out9a <= b_out9;

always @ (posedge clk)
b_out10a <= b_out10;

always @ (posedge clk)
b_out11a <= b_out11;

always @ (posedge clk)
b_out12a <= b_out12;

always @ (posedge clk)
b_out13a <= b_out13;

always @ (posedge clk)
b_out14a <= b_out14;

always @ (posedge clk)
b_out15a <= b_out15;


reg signed [17:0] sys_out0a,sys_out1a,sys_out2a,sys_out3a,sys_out4a,sys_out5a,sys_out6a,sys_out7a;
reg signed [17:0] b_sys_out0a,b_sys_out1a,b_sys_out2a,b_sys_out3a,b_sys_out4a,b_sys_out5a,b_sys_out6a,b_sys_out7a;


always @ (posedge clk)
mult_1 <= sam_out0a*b_out0a;


always @ (posedge clk)
mult_2 <= sam_out1a*b_out1a;


always @ (posedge clk)
mult_3 <= sam_out2a*b_out2a;


always @ (posedge clk)
mult_4 <= sam_out3a*b_out3a;


always @ (posedge clk)
mult_5 <= sam_out4a*b_out4a;


always @ (posedge clk)
mult_6 <= sam_out5a*b_out5a;


always @ (posedge clk)
mult_7 <= sam_out6a*b_out6a;


always @ (posedge clk)
mult_8 <= sam_out7a*b_out7a;


always @ (posedge clk)
mult_9 <= sam_out8a*b_out8a;


always @ (posedge clk)
mult_10 <= sam_out9a*b_out9a;


always @ (posedge clk)
mult_11 <= sam_out10a*b_out10a;


always @ (posedge clk)
mult_12 <= sam_out11a*b_out11a;


always @ (posedge clk)
mult_13 <= sam_out12a*b_out12a;


always @ (posedge clk)
mult_14 <= sam_out13a*b_out13a;


always @ (posedge clk)
mult_15 <= sam_out14a*b_out14a;


always @ (posedge clk)
mult_16 <= sam_out15a*b_out15a;






reg signed [35:0] mult_acc1, mult_acc2, mult_acc3, mult_acc4,mult_acc5, mult_acc6, mult_acc7, mult_acc8,mult_acc9, mult_acc10, mult_acc11, mult_acc12,mult_acc13, mult_acc14, mult_acc15, mult_acc16;
reg signed [35:0] mult_acc1_delayed[2:0], mult_acc2_delayed[2:0], mult_acc3_delayed[2:0], mult_acc4_delayed[2:0],mult_out_delayed[2:0],mult_acc5_delayed[2:0], mult_acc6_delayed[2:0], mult_acc7_delayed[2:0], mult_acc8_delayed[2:0],mult_acc9_delayed[2:0], mult_acc10_delayed[2:0], mult_acc11_delayed[2:0], mult_acc12_delayed[2:0],mult_acc13_delayed[2:0], mult_acc14_delayed[2:0], mult_acc15_delayed[2:0], mult_acc16_delayed[2:0];

always @ (posedge clk)
if(clk_en)
mult_acc1 <= mult_1;
else
mult_acc1 <= mult_acc1 + mult_1;

always @ (posedge clk)
if(clk_en)
mult_acc2 <= mult_2;
else
mult_acc2 <= mult_acc2 + mult_2;

always @ (posedge clk)
if(clk_en)
mult_acc3 <= mult_3;
else
mult_acc3 <= mult_acc3 + mult_3;

always @ (posedge clk)
if(clk_en)
mult_acc4 <= mult_4;
else
mult_acc4 <= mult_acc4 + mult_4;


always @ (posedge clk)
if(clk_en)
mult_acc5 <= mult_5;
else
mult_acc5 <= mult_acc5 + mult_5;

always @ (posedge clk)
if(clk_en)
mult_acc6 <= mult_6;
else
mult_acc6 <= mult_acc6 + mult_6;

always @ (posedge clk)
if(clk_en)
mult_acc7 <= mult_7;
else
mult_acc7 <= mult_acc7 + mult_7;

always @ (posedge clk)
if(clk_en)
mult_acc8 <= mult_8;
else
mult_acc8 <= mult_acc8 + mult_8;

always @ (posedge clk)
if(clk_en)
mult_acc9 <= mult_9;
else
mult_acc9 <= mult_acc9 + mult_9;

always @ (posedge clk)
if(clk_en)
mult_acc10 <= mult_10;
else
mult_acc10 <= mult_acc10 + mult_10;

always @ (posedge clk)
if(clk_en)
mult_acc11 <= mult_11;
else
mult_acc11 <= mult_acc11 + mult_11;

always @ (posedge clk)
if(clk_en)
mult_acc12 <= mult_12;
else
mult_acc12 <= mult_acc12 + mult_12;


always @ (posedge clk)
if(clk_en)
mult_acc13 <= mult_13;
else
mult_acc13 <= mult_acc13 + mult_13;

always @ (posedge clk)
if(clk_en)
mult_acc14 <= mult_14;
else
mult_acc14 <= mult_acc14 + mult_14;

always @ (posedge clk)
if(clk_en)
mult_acc15 <= mult_15;
else
mult_acc15 <= mult_acc15 + mult_15;

always @ (posedge clk)
if(clk_en)
mult_acc16 <= mult_16;
else
mult_acc16 <= mult_acc16 + mult_16;




// unsymetric bit
always @ (posedge clk)
if(clk_en)
mult_out <= sum_level_1[64] * b[64];
// add delays to accum
always @ (posedge clk)
if(clk_en)
mult_acc1_delayed[0] <= mult_acc1;

always @ (posedge clk)
if(clk_en)
mult_acc2_delayed[0] <= mult_acc2;

always @ (posedge clk)
if(clk_en)
mult_acc3_delayed[0] <= mult_acc3;

always @ (posedge clk)
if(clk_en)
mult_acc4_delayed[0] <= mult_acc4;

always @ (posedge clk)
mult_acc5_delayed[0] <= mult_acc5;

always @ (posedge clk)
if(clk_en)
mult_acc6_delayed[0] <= mult_acc6;

always @ (posedge clk)
if(clk_en)
mult_acc7_delayed[0] <= mult_acc7;

always @ (posedge clk)
if(clk_en)
mult_acc8_delayed[0] <= mult_acc8;


always @ (posedge clk)
if(clk_en)
mult_acc9_delayed[0] <= mult_acc9;

always @ (posedge clk)
if(clk_en)
mult_acc10_delayed[0] <= mult_acc10;

always @ (posedge clk)
if(clk_en)
mult_acc11_delayed[0] <= mult_acc11;

always @ (posedge clk)
if(clk_en)
mult_acc12_delayed[0] <= mult_acc12;


always @ (posedge clk)
if(clk_en)
mult_acc13_delayed[0] <= mult_acc13;

always @ (posedge clk)
if(clk_en)
mult_acc14_delayed[0] <= mult_acc14;

always @ (posedge clk)
if(clk_en)
mult_acc15_delayed[0] <= mult_acc15;

always @ (posedge clk)
if(clk_en)
mult_acc16_delayed[0] <= mult_acc16;




always @ (posedge clk)
if(clk_en)
mult_out_delayed[0] <= mult_out;

always @ (posedge clk)
for(i=1;i<3;i=i+1)
mult_acc1_delayed[i]<=mult_acc1_delayed[i-1];

always @ (posedge clk)
for(i=1;i<3;i=i+1)
mult_acc2_delayed[i]<=mult_acc2_delayed[i-1];

always @ (posedge clk)
for(i=1;i<3;i=i+1)
mult_acc3_delayed[i]<=mult_acc3_delayed[i-1];

always @ (posedge clk)
for(i=1;i<3;i=i+1)
mult_acc4_delayed[i]<=mult_acc4_delayed[i-1];

always @ (posedge clk)
for(i=1;i<3;i=i+1)
mult_out_delayed[i]<=mult_out_delayed[i-1];



always @ *
sum_level_5 <= mult_acc1_delayed[0]+mult_acc2_delayed[0]+mult_acc3_delayed[0]+mult_acc4_delayed[0]+mult_out_delayed[0]+mult_acc5_delayed[0]+mult_acc6_delayed[0]+mult_acc7_delayed[0]+mult_acc8_delayed[0]+mult_acc9_delayed[0]+mult_acc10_delayed[0]+mult_acc11_delayed[0]+mult_acc12_delayed[0]+mult_acc13_delayed[0]+mult_acc14_delayed[0]+mult_acc15_delayed[0]+mult_acc16_delayed[0];

always @ (posedge clk)
if(clk_en)
y <= sum_level_5[35:18];



always @ *
   begin
b[0] <= -18'sd91;
b[1] <= -18'sd35;
b[2] <= 18'sd53;
b[3] <= 18'sd110;
b[4] <= 18'sd92;
b[5] <= 18'sd6;
b[6] <= -18'sd92;
b[7] <= -18'sd130;
b[8] <= -18'sd79;
b[9] <= 18'sd32;
b[10] <= 18'sd126;
b[11] <= 18'sd135;
b[12] <= 18'sd48;
b[13] <= -18'sd77;
b[14] <= -18'sd150;
b[15] <= -18'sd117;
b[16] <= 18'sd3;
b[17] <= 18'sd123;
b[18] <= 18'sd154;
b[19] <= 18'sd68;
b[20] <= -18'sd73;
b[21] <= -18'sd164;
b[22] <= -18'sd128;
b[23] <= 18'sd17;
b[24] <= 18'sd164;
b[25] <= 18'sd191;
b[26] <= 18'sd60;
b[27] <= -18'sd146;
b[28] <= -18'sd271;
b[29] <= -18'sd194;
b[30] <= 18'sd61;
b[31] <= 18'sd327;
b[32] <= 18'sd391;
b[33] <= 18'sd160;
b[34] <= -18'sd252;
b[35] <= -18'sd566;
b[36] <= -18'sd520;
b[37] <= -18'sd72;
b[38] <= 18'sd532;
b[39] <= 18'sd875;
b[40] <= 18'sd651;
b[41] <= -18'sd95;
b[42] <= -18'sd931;
b[43] <= -18'sd1274;
b[44] <= -18'sd778;
b[45] <= 18'sd376;
b[46] <= 18'sd1504;
b[47] <= 18'sd1804;
b[48] <= 18'sd893;
b[49] <= -18'sd843;
b[50] <= -18'sd2364;
b[51] <= -18'sd2559;
b[52] <= -18'sd991;
b[53] <= 18'sd1661;
b[54] <= 18'sd3809;
b[55] <= 18'sd3816;
b[56] <= 18'sd1065;
b[57] <= -18'sd3370;
b[58] <= -18'sd6943;
b[59] <= -18'sd6760;
b[60] <= -18'sd1111;
b[61] <= 18'sd9397;
b[62] <= 18'sd21758;
b[63] <= 18'sd31692;
b[64] <= 18'sd35490;
   end

   endmodule