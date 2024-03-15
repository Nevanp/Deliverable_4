module gs_rx_filter(
          input clk,
          input clk_en,
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
reg signed [18:0]	x[128:0];	
reg signed [36:0] mult_out[64:0];
reg signed [18:0] sum_level_1[64:0];
reg signed [35:0] sum_level_2[32:0];
reg signed [35:0] sum_level_3[16:0];
reg signed [35:0] sum_level_4[8:0];
reg signed [35:0] sum_level_5;

always @ (posedge clk)
if(clk_en)
x[0] <= {x_in[17],x_in};
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
sum_level_1[i] <= x[i]+x[128-i];

always @ *
sum_level_1[64] <= x[64];


// always @ (posedge clk)
always @ *
for(i=0;i<=64; i=i+1)
mult_out[i] <= sum_level_1[i] * b[i];

// collapse mult_out into sum level 2, since 0:10 is odd: add 0:9 and set 10
 always @ *
for(i=0;i<=31;i=i+1)
sum_level_2[i] <= mult_out[2*i][35:0] + mult_out[2*i+1][35:0];

always @ *
sum_level_2[32] <= mult_out[64][35:0];

// simular to prev but even so can straight sum
always @ *
for(i=0;i<=15;i=i+1)
sum_level_3[i] <= sum_level_2[2*i] + sum_level_2[2*i+1];
			
			
always @ *
sum_level_3[16] <= sum_level_2[32];


always @ *
for(i=0;i<=7;i=i+1)
sum_level_4[i] <= sum_level_3[2*i] + sum_level_3[2*i+1];

always @ *
sum_level_4[8] <= sum_level_3[16];

always @ *
sum_level_5 <= sum_level_4[0] + sum_level_4[1] + sum_level_4[2] + sum_level_4[3] + sum_level_4[4] + sum_level_4[5] + sum_level_4[6] + sum_level_4[7] + sum_level_4[8];

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