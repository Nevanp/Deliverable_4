module tx_practical(
          input clk, //system clock
			input sam_clk, //sampling clock
			input signed [17:0]x_in, //upsampled input value 1s17
			output reg signed [17:0]y //output of filter 1s17
			);


integer i;					 
reg signed [17:0]	x[112:0];	
reg signed [17:0] mult_out[56:0];
reg signed [17:0] multout[56:0];
reg unsigned [4:0] sum_level_1[56:0];
reg signed [17:0] sum_level_2[28:0];
reg signed [17:0] sum_level_3[14:0];
reg signed [17:0] sum_level_4[7:0];
reg signed [17:0] sum_level_5[3:0];
reg signed [17:0] sum_level_6[1:0];
reg signed [17:0] sum_level_7;

// always @ (reset)
// begin
// for(i=0; i<20;i=i+1)
// x[i] <= 0;
// end
// always @ (reset)
// begin
// for(i=0; i<10;i=i+1)
// mult_out[i] <= 0;
// end
// always @ (reset)
// begin
// for(i=0; i<10;i=i+1)
// sum_level_1[i] <= 0;
// end
// always @ (reset)
// begin
// for(i=0; i<5;i=i+1)
// sum_level_2[i] <= 0;
// end
// always @ (reset)
// begin
// for(i=0; i<2;i=i+1)
// sum_level_3[i] <= 0;
// end
// always @ (reset)
// begin
// for(i=0; i<1;i=i+1)
// sum_level_4[i] <= 0;
// end
// always @ (reset)
// sum_level_5 <= 0;





always @ (posedge clk)
if(sam_clk)
x[0] <= x_in;
else
x[0]<= x[0];

always @ (posedge clk)
if(sam_clk)
begin
for(i=1; i<113;i=i+1)
x[i] <= x[i-1];
end


always @ *
for(i=0;i<=55;i=i+1)
sum_level_1[i] <= x[i][17:14]+x[112-i][17:14];

always @ *
sum_level_1[56] <= x[56][17:14];


// always @ (posedge clk)
always @ *
for(i=0;i<=56;i=i+1)
mult_out[i] <= multout[i];

// collapse mult_out into sum level 2, since 0:10 is odd: add 0:9 and set 10
 always @ *
for(i=0;i<=27;i=i+1)
sum_level_2[i] <= mult_out[2*i] + mult_out[2*i+1];

always @ *
sum_level_2[28] <= mult_out[56];

// simular to prev but even so can straight sum
always @ *
for(i=0;i<=13;i=i+1)
sum_level_3[i] <= sum_level_2[2*i] + sum_level_2[2*i+1];
			
always @ *
sum_level_3[14] <= sum_level_2[28];

always @ *
for(i=0; i<=6;i=i+1)
sum_level_4[i] <= sum_level_3[2*i] + sum_level_3[2*i+1];

always @ *
sum_level_4[7] <= sum_level_3[14];

always @ *
for(i=0; i<=3;i=i+1)
sum_level_5[i] <= sum_level_4[2*i] + sum_level_4[2*i+1];

always @ *
for(i=0; i<2;i=i+1)
sum_level_6[i] <= sum_level_5[i*2]+sum_level_5[2*i+1];

always @ *
sum_level_7 <= sum_level_6[0]+sum_level_6[1];

always @ (posedge clk)
if(sam_clk)
y <= sum_level_7[17:0];


always @ (*)
begin
casez(sum_level_1[0])
5'b10000: multout[0] <= -18'sd174;
5'b10101: multout[0] <= -18'sd116;
5'b01000: multout[0] <= -18'sd87;
5'bz1010: multout[0] <= -18'sd59;
5'b01101: multout[0] <= -18'sd29;
5'b00000: multout[0] <= 18'sd0;
5'b00010: multout[0] <= 18'sd28;
5'bz0100: multout[0] <= 18'sd58;
5'b00111: multout[0] <= 18'sd87;
5'b01001: multout[0] <= 18'sd115;
5'b01110: multout[0] <= 18'sd174;
default: multout[0] <= 18'sd0;
endcase

casez(sum_level_1[1])
5'b10000: multout[1] <= -18'sd152;
5'b10101: multout[1] <= -18'sd102;
5'b01000: multout[1] <= -18'sd76;
5'bz1010: multout[1] <= -18'sd51;
5'b01101: multout[1] <= -18'sd26;
5'b00000: multout[1] <= 18'sd0;
5'b00010: multout[1] <= 18'sd25;
5'bz0100: multout[1] <= 18'sd50;
5'b00111: multout[1] <= 18'sd76;
5'b01001: multout[1] <= 18'sd101;
5'b01110: multout[1] <= 18'sd152;
default: multout[1] <= 18'sd0;
endcase

casez(sum_level_1[2])
5'b10000: multout[2] <= -18'sd6;
5'b10101: multout[2] <= -18'sd4;
5'b01000: multout[2] <= -18'sd3;
5'bz1010: multout[2] <= -18'sd3;
5'b01101: multout[2] <= -18'sd1;
5'b00000: multout[2] <= 18'sd0;
5'b00010: multout[2] <= 18'sd0;
5'bz0100: multout[2] <= 18'sd2;
5'b00111: multout[2] <= 18'sd3;
5'b01001: multout[2] <= 18'sd3;
5'b01110: multout[2] <= 18'sd6;
default: multout[2] <= 18'sd0;
endcase

casez(sum_level_1[3])
5'b10000: multout[3] <= 18'sd176;
5'b10101: multout[3] <= 18'sd117;
5'b01000: multout[3] <= 18'sd88;
5'bz1010: multout[3] <= 18'sd58;
5'b01101: multout[3] <= 18'sd29;
5'b00000: multout[3] <= 18'sd0;
5'b00010: multout[3] <= -18'sd30;
5'bz0100: multout[3] <= -18'sd59;
5'b00111: multout[3] <= -18'sd88;
5'b01001: multout[3] <= -18'sd118;
5'b01110: multout[3] <= -18'sd176;
default: multout[3] <= 18'sd0;
endcase

casez(sum_level_1[4])
5'b10000: multout[4] <= 18'sd264;
5'b10101: multout[4] <= 18'sd175;
5'b01000: multout[4] <= 18'sd132;
5'bz1010: multout[4] <= 18'sd88;
5'b01101: multout[4] <= 18'sd43;
5'b00000: multout[4] <= 18'sd0;
5'b00010: multout[4] <= -18'sd44;
5'bz0100: multout[4] <= -18'sd89;
5'b00111: multout[4] <= -18'sd132;
5'b01001: multout[4] <= -18'sd176;
5'b01110: multout[4] <= -18'sd264;
default: multout[4] <= 18'sd0;
endcase

casez(sum_level_1[5])
5'b10000: multout[5] <= 18'sd166;
5'b10101: multout[5] <= 18'sd110;
5'b01000: multout[5] <= 18'sd83;
5'bz1010: multout[5] <= 18'sd55;
5'b01101: multout[5] <= 18'sd27;
5'b00000: multout[5] <= 18'sd0;
5'b00010: multout[5] <= -18'sd28;
5'bz0100: multout[5] <= -18'sd56;
5'b00111: multout[5] <= -18'sd83;
5'b01001: multout[5] <= -18'sd111;
5'b01110: multout[5] <= -18'sd166;
default: multout[5] <= 18'sd0;
endcase

casez(sum_level_1[6])
5'b10000: multout[6] <= -18'sd78;
5'b10101: multout[6] <= -18'sd52;
5'b01000: multout[6] <= -18'sd39;
5'bz1010: multout[6] <= -18'sd27;
5'b01101: multout[6] <= -18'sd13;
5'b00000: multout[6] <= 18'sd0;
5'b00010: multout[6] <= 18'sd12;
5'bz0100: multout[6] <= 18'sd26;
5'b00111: multout[6] <= 18'sd39;
5'b01001: multout[6] <= 18'sd51;
5'b01110: multout[6] <= 18'sd78;
default: multout[6] <= 18'sd0;
endcase

casez(sum_level_1[7])
5'b10000: multout[7] <= -18'sd320;
5'b10101: multout[7] <= -18'sd214;
5'b01000: multout[7] <= -18'sd160;
5'bz1010: multout[7] <= -18'sd107;
5'b01101: multout[7] <= -18'sd54;
5'b00000: multout[7] <= 18'sd0;
5'b00010: multout[7] <= 18'sd53;
5'bz0100: multout[7] <= 18'sd106;
5'b00111: multout[7] <= 18'sd160;
5'b01001: multout[7] <= 18'sd213;
5'b01110: multout[7] <= 18'sd320;
default: multout[7] <= 18'sd0;
endcase

casez(sum_level_1[8])
5'b10000: multout[8] <= -18'sd374;
5'b10101: multout[8] <= -18'sd250;
5'b01000: multout[8] <= -18'sd187;
5'bz1010: multout[8] <= -18'sd125;
5'b01101: multout[8] <= -18'sd63;
5'b00000: multout[8] <= 18'sd0;
5'b00010: multout[8] <= 18'sd62;
5'bz0100: multout[8] <= 18'sd124;
5'b00111: multout[8] <= 18'sd187;
5'b01001: multout[8] <= 18'sd249;
5'b01110: multout[8] <= 18'sd374;
default: multout[8] <= 18'sd0;
endcase

casez(sum_level_1[9])
5'b10000: multout[9] <= -18'sd162;
5'b10101: multout[9] <= -18'sd108;
5'b01000: multout[9] <= -18'sd81;
5'bz1010: multout[9] <= -18'sd55;
5'b01101: multout[9] <= -18'sd27;
5'b00000: multout[9] <= 18'sd0;
5'b00010: multout[9] <= 18'sd26;
5'bz0100: multout[9] <= 18'sd54;
5'b00111: multout[9] <= 18'sd81;
5'b01001: multout[9] <= 18'sd107;
5'b01110: multout[9] <= 18'sd162;
default: multout[9] <= 18'sd0;
endcase

casez(sum_level_1[10])
5'b10000: multout[10] <= 18'sd216;
5'b10101: multout[10] <= 18'sd143;
5'b01000: multout[10] <= 18'sd108;
5'bz1010: multout[10] <= 18'sd72;
5'b01101: multout[10] <= 18'sd35;
5'b00000: multout[10] <= 18'sd0;
5'b00010: multout[10] <= -18'sd36;
5'bz0100: multout[10] <= -18'sd73;
5'b00111: multout[10] <= -18'sd108;
5'b01001: multout[10] <= -18'sd144;
5'b01110: multout[10] <= -18'sd216;
default: multout[10] <= 18'sd0;
endcase

casez(sum_level_1[11])
5'b10000: multout[11] <= 18'sd516;
5'b10101: multout[11] <= 18'sd343;
5'b01000: multout[11] <= 18'sd258;
5'bz1010: multout[11] <= 18'sd172;
5'b01101: multout[11] <= 18'sd85;
5'b00000: multout[11] <= 18'sd0;
5'b00010: multout[11] <= -18'sd86;
5'bz0100: multout[11] <= -18'sd173;
5'b00111: multout[11] <= -18'sd258;
5'b01001: multout[11] <= -18'sd344;
5'b01110: multout[11] <= -18'sd516;
default: multout[11] <= 18'sd0;
endcase

casez(sum_level_1[12])
5'b10000: multout[12] <= 18'sd504;
5'b10101: multout[12] <= 18'sd335;
5'b01000: multout[12] <= 18'sd252;
5'bz1010: multout[12] <= 18'sd168;
5'b01101: multout[12] <= 18'sd83;
5'b00000: multout[12] <= 18'sd0;
5'b00010: multout[12] <= -18'sd84;
5'bz0100: multout[12] <= -18'sd169;
5'b00111: multout[12] <= -18'sd252;
5'b01001: multout[12] <= -18'sd336;
5'b01110: multout[12] <= -18'sd504;
default: multout[12] <= 18'sd0;
endcase

casez(sum_level_1[13])
5'b10000: multout[13] <= 18'sd126;
5'b10101: multout[13] <= 18'sd83;
5'b01000: multout[13] <= 18'sd63;
5'bz1010: multout[13] <= 18'sd42;
5'b01101: multout[13] <= 18'sd20;
5'b00000: multout[13] <= 18'sd0;
5'b00010: multout[13] <= -18'sd21;
5'bz0100: multout[13] <= -18'sd43;
5'b00111: multout[13] <= -18'sd63;
5'b01001: multout[13] <= -18'sd84;
5'b01110: multout[13] <= -18'sd126;
default: multout[13] <= 18'sd0;
endcase

casez(sum_level_1[14])
5'b10000: multout[14] <= -18'sd420;
5'b10101: multout[14] <= -18'sd280;
5'b01000: multout[14] <= -18'sd210;
5'bz1010: multout[14] <= -18'sd141;
5'b01101: multout[14] <= -18'sd70;
5'b00000: multout[14] <= 18'sd0;
5'b00010: multout[14] <= 18'sd69;
5'bz0100: multout[14] <= 18'sd140;
5'b00111: multout[14] <= 18'sd210;
5'b01001: multout[14] <= 18'sd279;
5'b01110: multout[14] <= 18'sd420;
default: multout[14] <= 18'sd0;
endcase

casez(sum_level_1[15])
5'b10000: multout[15] <= -18'sd774;
5'b10101: multout[15] <= -18'sd516;
5'b01000: multout[15] <= -18'sd387;
5'bz1010: multout[15] <= -18'sd259;
5'b01101: multout[15] <= -18'sd129;
5'b00000: multout[15] <= 18'sd0;
5'b00010: multout[15] <= 18'sd128;
5'bz0100: multout[15] <= 18'sd258;
5'b00111: multout[15] <= 18'sd387;
5'b01001: multout[15] <= 18'sd515;
5'b01110: multout[15] <= 18'sd774;
default: multout[15] <= 18'sd0;
endcase

casez(sum_level_1[16])
5'b10000: multout[16] <= -18'sd652;
5'b10101: multout[16] <= -18'sd435;
5'b01000: multout[16] <= -18'sd326;
5'bz1010: multout[16] <= -18'sd218;
5'b01101: multout[16] <= -18'sd109;
5'b00000: multout[16] <= 18'sd0;
5'b00010: multout[16] <= 18'sd108;
5'bz0100: multout[16] <= 18'sd217;
5'b00111: multout[16] <= 18'sd326;
5'b01001: multout[16] <= 18'sd434;
5'b01110: multout[16] <= 18'sd652;
default: multout[16] <= 18'sd0;
endcase

casez(sum_level_1[17])
5'b10000: multout[17] <= -18'sd46;
5'b10101: multout[17] <= -18'sd31;
5'b01000: multout[17] <= -18'sd23;
5'bz1010: multout[17] <= -18'sd16;
5'b01101: multout[17] <= -18'sd8;
5'b00000: multout[17] <= 18'sd0;
5'b00010: multout[17] <= 18'sd7;
5'bz0100: multout[17] <= 18'sd15;
5'b00111: multout[17] <= 18'sd23;
5'b01001: multout[17] <= 18'sd30;
5'b01110: multout[17] <= 18'sd46;
default: multout[17] <= 18'sd0;
endcase

casez(sum_level_1[18])
5'b10000: multout[18] <= 18'sd708;
5'b10101: multout[18] <= 18'sd471;
5'b01000: multout[18] <= 18'sd354;
5'bz1010: multout[18] <= 18'sd236;
5'b01101: multout[18] <= 18'sd117;
5'b00000: multout[18] <= 18'sd0;
5'b00010: multout[18] <= -18'sd118;
5'bz0100: multout[18] <= -18'sd237;
5'b00111: multout[18] <= -18'sd354;
5'b01001: multout[18] <= -18'sd472;
5'b01110: multout[18] <= -18'sd708;
default: multout[18] <= 18'sd0;
endcase

casez(sum_level_1[19])
5'b10000: multout[19] <= 18'sd1108;
5'b10101: multout[19] <= 18'sd738;
5'b01000: multout[19] <= 18'sd554;
5'bz1010: multout[19] <= 18'sd369;
5'b01101: multout[19] <= 18'sd184;
5'b00000: multout[19] <= 18'sd0;
5'b00010: multout[19] <= -18'sd185;
5'bz0100: multout[19] <= -18'sd370;
5'b00111: multout[19] <= -18'sd554;
5'b01001: multout[19] <= -18'sd739;
5'b01110: multout[19] <= -18'sd1108;
default: multout[19] <= 18'sd0;
endcase

casez(sum_level_1[20])
5'b10000: multout[20] <= 18'sd814;
5'b10101: multout[20] <= 18'sd542;
5'b01000: multout[20] <= 18'sd407;
5'bz1010: multout[20] <= 18'sd271;
5'b01101: multout[20] <= 18'sd135;
5'b00000: multout[20] <= 18'sd0;
5'b00010: multout[20] <= -18'sd136;
5'bz0100: multout[20] <= -18'sd272;
5'b00111: multout[20] <= -18'sd407;
5'b01001: multout[20] <= -18'sd543;
5'b01110: multout[20] <= -18'sd814;
default: multout[20] <= 18'sd0;
endcase

casez(sum_level_1[21])
5'b10000: multout[21] <= -18'sd98;
5'b10101: multout[21] <= -18'sd66;
5'b01000: multout[21] <= -18'sd49;
5'bz1010: multout[21] <= -18'sd33;
5'b01101: multout[21] <= -18'sd17;
5'b00000: multout[21] <= 18'sd0;
5'b00010: multout[21] <= 18'sd16;
5'bz0100: multout[21] <= 18'sd32;
5'b00111: multout[21] <= 18'sd49;
5'b01001: multout[21] <= 18'sd65;
5'b01110: multout[21] <= 18'sd98;
default: multout[21] <= 18'sd0;
endcase

casez(sum_level_1[22])
5'b10000: multout[22] <= -18'sd1104;
5'b10101: multout[22] <= -18'sd736;
5'b01000: multout[22] <= -18'sd552;
5'bz1010: multout[22] <= -18'sd369;
5'b01101: multout[22] <= -18'sd184;
5'b00000: multout[22] <= 18'sd0;
5'b00010: multout[22] <= 18'sd183;
5'bz0100: multout[22] <= 18'sd368;
5'b00111: multout[22] <= 18'sd552;
5'b01001: multout[22] <= 18'sd735;
5'b01110: multout[22] <= 18'sd1104;
default: multout[22] <= 18'sd0;
endcase

casez(sum_level_1[23])
5'b10000: multout[23] <= -18'sd1530;
5'b10101: multout[23] <= -18'sd1020;
5'b01000: multout[23] <= -18'sd765;
5'bz1010: multout[23] <= -18'sd511;
5'b01101: multout[23] <= -18'sd255;
5'b00000: multout[23] <= 18'sd0;
5'b00010: multout[23] <= 18'sd254;
5'bz0100: multout[23] <= 18'sd510;
5'b00111: multout[23] <= 18'sd765;
5'b01001: multout[23] <= 18'sd1019;
5'b01110: multout[23] <= 18'sd1530;
default: multout[23] <= 18'sd0;
endcase

casez(sum_level_1[24])
5'b10000: multout[24] <= -18'sd984;
5'b10101: multout[24] <= -18'sd656;
5'b01000: multout[24] <= -18'sd492;
5'bz1010: multout[24] <= -18'sd329;
5'b01101: multout[24] <= -18'sd164;
5'b00000: multout[24] <= 18'sd0;
5'b00010: multout[24] <= 18'sd163;
5'bz0100: multout[24] <= 18'sd328;
5'b00111: multout[24] <= 18'sd492;
5'b01001: multout[24] <= 18'sd655;
5'b01110: multout[24] <= 18'sd984;
default: multout[24] <= 18'sd0;
endcase

casez(sum_level_1[25])
5'b10000: multout[25] <= 18'sd328;
5'b10101: multout[25] <= 18'sd218;
5'b01000: multout[25] <= 18'sd164;
5'bz1010: multout[25] <= 18'sd109;
5'b01101: multout[25] <= 18'sd54;
5'b00000: multout[25] <= 18'sd0;
5'b00010: multout[25] <= -18'sd55;
5'bz0100: multout[25] <= -18'sd110;
5'b00111: multout[25] <= -18'sd164;
5'b01001: multout[25] <= -18'sd219;
5'b01110: multout[25] <= -18'sd328;
default: multout[25] <= 18'sd0;
endcase

casez(sum_level_1[26])
5'b10000: multout[26] <= 18'sd1640;
5'b10101: multout[26] <= 18'sd1093;
5'b01000: multout[26] <= 18'sd820;
5'bz1010: multout[26] <= 18'sd546;
5'b01101: multout[26] <= 18'sd273;
5'b00000: multout[26] <= 18'sd0;
5'b00010: multout[26] <= -18'sd274;
5'bz0100: multout[26] <= -18'sd547;
5'b00111: multout[26] <= -18'sd820;
5'b01001: multout[26] <= -18'sd1094;
5'b01110: multout[26] <= -18'sd1640;
default: multout[26] <= 18'sd0;
endcase

casez(sum_level_1[27])
5'b10000: multout[27] <= 18'sd2060;
5'b10101: multout[27] <= 18'sd1373;
5'b01000: multout[27] <= 18'sd1030;
5'bz1010: multout[27] <= 18'sd686;
5'b01101: multout[27] <= 18'sd343;
5'b00000: multout[27] <= 18'sd0;
5'b00010: multout[27] <= -18'sd344;
5'bz0100: multout[27] <= -18'sd687;
5'b00111: multout[27] <= -18'sd1030;
5'b01001: multout[27] <= -18'sd1374;
5'b01110: multout[27] <= -18'sd2060;
default: multout[27] <= 18'sd0;
endcase

casez(sum_level_1[28])
5'b10000: multout[28] <= 18'sd1158;
5'b10101: multout[28] <= 18'sd771;
5'b01000: multout[28] <= 18'sd579;
5'bz1010: multout[28] <= 18'sd386;
5'b01101: multout[28] <= 18'sd192;
5'b00000: multout[28] <= 18'sd0;
5'b00010: multout[28] <= -18'sd193;
5'bz0100: multout[28] <= -18'sd387;
5'b00111: multout[28] <= -18'sd579;
5'b01001: multout[28] <= -18'sd772;
5'b01110: multout[28] <= -18'sd1158;
default: multout[28] <= 18'sd0;
endcase

casez(sum_level_1[29])
5'b10000: multout[29] <= -18'sd676;
5'b10101: multout[29] <= -18'sd451;
5'b01000: multout[29] <= -18'sd338;
5'bz1010: multout[29] <= -18'sd226;
5'b01101: multout[29] <= -18'sd113;
5'b00000: multout[29] <= 18'sd0;
5'b00010: multout[29] <= 18'sd112;
5'bz0100: multout[29] <= 18'sd225;
5'b00111: multout[29] <= 18'sd338;
5'b01001: multout[29] <= 18'sd450;
5'b01110: multout[29] <= 18'sd676;
default: multout[29] <= 18'sd0;
endcase

casez(sum_level_1[30])
5'b10000: multout[30] <= -18'sd2356;
5'b10101: multout[30] <= -18'sd1571;
5'b01000: multout[30] <= -18'sd1178;
5'bz1010: multout[30] <= -18'sd786;
5'b01101: multout[30] <= -18'sd393;
5'b00000: multout[30] <= 18'sd0;
5'b00010: multout[30] <= 18'sd392;
5'bz0100: multout[30] <= 18'sd785;
5'b00111: multout[30] <= 18'sd1178;
5'b01001: multout[30] <= 18'sd1570;
5'b01110: multout[30] <= 18'sd2356;
default: multout[30] <= 18'sd0;
endcase

casez(sum_level_1[31])
5'b10000: multout[31] <= -18'sd2728;
5'b10101: multout[31] <= -18'sd1819;
5'b01000: multout[31] <= -18'sd1364;
5'bz1010: multout[31] <= -18'sd910;
5'b01101: multout[31] <= -18'sd455;
5'b00000: multout[31] <= 18'sd0;
5'b00010: multout[31] <= 18'sd454;
5'bz0100: multout[31] <= 18'sd909;
5'b00111: multout[31] <= 18'sd1364;
5'b01001: multout[31] <= 18'sd1818;
5'b01110: multout[31] <= 18'sd2728;
default: multout[31] <= 18'sd0;
endcase

casez(sum_level_1[32])
5'b10000: multout[32] <= -18'sd1328;
5'b10101: multout[32] <= -18'sd886;
5'b01000: multout[32] <= -18'sd664;
5'bz1010: multout[32] <= -18'sd443;
5'b01101: multout[32] <= -18'sd222;
5'b00000: multout[32] <= 18'sd0;
5'b00010: multout[32] <= 18'sd221;
5'bz0100: multout[32] <= 18'sd442;
5'b00111: multout[32] <= 18'sd664;
5'b01001: multout[32] <= 18'sd885;
5'b01110: multout[32] <= 18'sd1328;
default: multout[32] <= 18'sd0;
endcase

casez(sum_level_1[33])
5'b10000: multout[33] <= 18'sd1194;
5'b10101: multout[33] <= 18'sd795;
5'b01000: multout[33] <= 18'sd597;
5'bz1010: multout[33] <= 18'sd398;
5'b01101: multout[33] <= 18'sd198;
5'b00000: multout[33] <= 18'sd0;
5'b00010: multout[33] <= -18'sd199;
5'bz0100: multout[33] <= -18'sd399;
5'b00111: multout[33] <= -18'sd597;
5'b01001: multout[33] <= -18'sd796;
5'b01110: multout[33] <= -18'sd1194;
default: multout[33] <= 18'sd0;
endcase

casez(sum_level_1[34])
5'b10000: multout[34] <= 18'sd3330;
5'b10101: multout[34] <= 18'sd2219;
5'b01000: multout[34] <= 18'sd1665;
5'bz1010: multout[34] <= 18'sd1110;
5'b01101: multout[34] <= 18'sd554;
5'b00000: multout[34] <= 18'sd0;
5'b00010: multout[34] <= -18'sd555;
5'bz0100: multout[34] <= -18'sd1111;
5'b00111: multout[34] <= -18'sd1665;
5'b01001: multout[34] <= -18'sd2220;
5'b01110: multout[34] <= -18'sd3330;
default: multout[34] <= 18'sd0;
endcase

casez(sum_level_1[35])
5'b10000: multout[35] <= 18'sd3588;
5'b10101: multout[35] <= 18'sd2391;
5'b01000: multout[35] <= 18'sd1794;
5'bz1010: multout[35] <= 18'sd1196;
5'b01101: multout[35] <= 18'sd597;
5'b00000: multout[35] <= 18'sd0;
5'b00010: multout[35] <= -18'sd598;
5'bz0100: multout[35] <= -18'sd1197;
5'b00111: multout[35] <= -18'sd1794;
5'b01001: multout[35] <= -18'sd2392;
5'b01110: multout[35] <= -18'sd3588;
default: multout[35] <= 18'sd0;
endcase

casez(sum_level_1[36])
5'b10000: multout[36] <= 18'sd1488;
5'b10101: multout[36] <= 18'sd991;
5'b01000: multout[36] <= 18'sd744;
5'bz1010: multout[36] <= 18'sd496;
5'b01101: multout[36] <= 18'sd247;
5'b00000: multout[36] <= 18'sd0;
5'b00010: multout[36] <= -18'sd248;
5'bz0100: multout[36] <= -18'sd497;
5'b00111: multout[36] <= -18'sd744;
5'b01001: multout[36] <= -18'sd992;
5'b01110: multout[36] <= -18'sd1488;
default: multout[36] <= 18'sd0;
endcase

casez(sum_level_1[37])
5'b10000: multout[37] <= -18'sd1966;
5'b10101: multout[37] <= -18'sd1311;
5'b01000: multout[37] <= -18'sd983;
5'bz1010: multout[37] <= -18'sd656;
5'b01101: multout[37] <= -18'sd328;
5'b00000: multout[37] <= 18'sd0;
5'b00010: multout[37] <= 18'sd327;
5'bz0100: multout[37] <= 18'sd655;
5'b00111: multout[37] <= 18'sd983;
5'b01001: multout[37] <= 18'sd1310;
5'b01110: multout[37] <= 18'sd1966;
default: multout[37] <= 18'sd0;
endcase

casez(sum_level_1[38])
5'b10000: multout[38] <= -18'sd4694;
5'b10101: multout[38] <= -18'sd3130;
5'b01000: multout[38] <= -18'sd2347;
5'bz1010: multout[38] <= -18'sd1565;
5'b01101: multout[38] <= -18'sd783;
5'b00000: multout[38] <= 18'sd0;
5'b00010: multout[38] <= 18'sd782;
5'bz0100: multout[38] <= 18'sd1564;
5'b00111: multout[38] <= 18'sd2347;
5'b01001: multout[38] <= 18'sd3129;
5'b01110: multout[38] <= 18'sd4694;
default: multout[38] <= 18'sd0;
endcase

casez(sum_level_1[39])
5'b10000: multout[39] <= -18'sd4752;
5'b10101: multout[39] <= -18'sd3168;
5'b01000: multout[39] <= -18'sd2376;
5'bz1010: multout[39] <= -18'sd1585;
5'b01101: multout[39] <= -18'sd792;
5'b00000: multout[39] <= 18'sd0;
5'b00010: multout[39] <= 18'sd791;
5'bz0100: multout[39] <= 18'sd1584;
5'b00111: multout[39] <= 18'sd2376;
5'b01001: multout[39] <= 18'sd3167;
5'b01110: multout[39] <= 18'sd4752;
default: multout[39] <= 18'sd0;
endcase

casez(sum_level_1[40])
5'b10000: multout[40] <= -18'sd1630;
5'b10101: multout[40] <= -18'sd1087;
5'b01000: multout[40] <= -18'sd815;
5'bz1010: multout[40] <= -18'sd544;
5'b01101: multout[40] <= -18'sd272;
5'b00000: multout[40] <= 18'sd0;
5'b00010: multout[40] <= 18'sd271;
5'bz0100: multout[40] <= 18'sd543;
5'b00111: multout[40] <= 18'sd815;
5'b01001: multout[40] <= 18'sd1086;
5'b01110: multout[40] <= 18'sd1630;
default: multout[40] <= 18'sd0;
endcase

casez(sum_level_1[41])
5'b10000: multout[41] <= 18'sd3166;
5'b10101: multout[41] <= 18'sd2110;
5'b01000: multout[41] <= 18'sd1583;
5'bz1010: multout[41] <= 18'sd1055;
5'b01101: multout[41] <= 18'sd527;
5'b00000: multout[41] <= 18'sd0;
5'b00010: multout[41] <= -18'sd528;
5'bz0100: multout[41] <= -18'sd1056;
5'b00111: multout[41] <= -18'sd1583;
5'b01001: multout[41] <= -18'sd2111;
5'b01110: multout[41] <= -18'sd3166;
default: multout[41] <= 18'sd0;
endcase

casez(sum_level_1[42])
5'b10000: multout[42] <= 18'sd6742;
5'b10101: multout[42] <= 18'sd4494;
5'b01000: multout[42] <= 18'sd3371;
5'bz1010: multout[42] <= 18'sd2247;
5'b01101: multout[42] <= 18'sd1123;
5'b00000: multout[42] <= 18'sd0;
5'b00010: multout[42] <= -18'sd1124;
5'bz0100: multout[42] <= -18'sd2248;
5'b00111: multout[42] <= -18'sd3371;
5'b01001: multout[42] <= -18'sd4495;
5'b01110: multout[42] <= -18'sd6742;
default: multout[42] <= 18'sd0;
endcase

casez(sum_level_1[43])
5'b10000: multout[43] <= 18'sd6472;
5'b10101: multout[43] <= 18'sd4314;
5'b01000: multout[43] <= 18'sd3236;
5'bz1010: multout[43] <= 18'sd2157;
5'b01101: multout[43] <= 18'sd1078;
5'b00000: multout[43] <= 18'sd0;
5'b00010: multout[43] <= -18'sd1079;
5'bz0100: multout[43] <= -18'sd2158;
5'b00111: multout[43] <= -18'sd3236;
5'b01001: multout[43] <= -18'sd4315;
5'b01110: multout[43] <= -18'sd6472;
default: multout[43] <= 18'sd0;
endcase

casez(sum_level_1[44])
5'b10000: multout[44] <= 18'sd1748;
5'b10101: multout[44] <= 18'sd1165;
5'b01000: multout[44] <= 18'sd874;
5'bz1010: multout[44] <= 18'sd582;
5'b01101: multout[44] <= 18'sd291;
5'b00000: multout[44] <= 18'sd0;
5'b00010: multout[44] <= -18'sd292;
5'bz0100: multout[44] <= -18'sd583;
5'b00111: multout[44] <= -18'sd874;
5'b01001: multout[44] <= -18'sd1166;
5'b01110: multout[44] <= -18'sd1748;
default: multout[44] <= 18'sd0;
endcase

casez(sum_level_1[45])
5'b10000: multout[45] <= -18'sd5214;
5'b10101: multout[45] <= -18'sd3476;
5'b01000: multout[45] <= -18'sd2607;
5'bz1010: multout[45] <= -18'sd1739;
5'b01101: multout[45] <= -18'sd869;
5'b00000: multout[45] <= 18'sd0;
5'b00010: multout[45] <= 18'sd868;
5'bz0100: multout[45] <= 18'sd1738;
5'b00111: multout[45] <= 18'sd2607;
5'b01001: multout[45] <= 18'sd3475;
5'b01110: multout[45] <= 18'sd5214;
default: multout[45] <= 18'sd0;
endcase

casez(sum_level_1[46])
5'b10000: multout[46] <= -18'sd10240;
5'b10101: multout[46] <= -18'sd6827;
5'b01000: multout[46] <= -18'sd5120;
5'bz1010: multout[46] <= -18'sd3414;
5'b01101: multout[46] <= -18'sd1707;
5'b00000: multout[46] <= 18'sd0;
5'b00010: multout[46] <= 18'sd1706;
5'bz0100: multout[46] <= 18'sd3413;
5'b00111: multout[46] <= 18'sd5120;
5'b01001: multout[46] <= 18'sd6826;
5'b01110: multout[46] <= 18'sd10240;
default: multout[46] <= 18'sd0;
endcase

casez(sum_level_1[47])
5'b10000: multout[47] <= -18'sd9458;
5'b10101: multout[47] <= -18'sd6306;
5'b01000: multout[47] <= -18'sd4729;
5'bz1010: multout[47] <= -18'sd3153;
5'b01101: multout[47] <= -18'sd1577;
5'b00000: multout[47] <= 18'sd0;
5'b00010: multout[47] <= 18'sd1576;
5'bz0100: multout[47] <= 18'sd3152;
5'b00111: multout[47] <= 18'sd4729;
5'b01001: multout[47] <= 18'sd6305;
5'b01110: multout[47] <= 18'sd9458;
default: multout[47] <= 18'sd0;
endcase

casez(sum_level_1[48])
5'b10000: multout[48] <= -18'sd1836;
5'b10101: multout[48] <= -18'sd1224;
5'b01000: multout[48] <= -18'sd918;
5'bz1010: multout[48] <= -18'sd613;
5'b01101: multout[48] <= -18'sd306;
5'b00000: multout[48] <= 18'sd0;
5'b00010: multout[48] <= 18'sd305;
5'bz0100: multout[48] <= 18'sd612;
5'b00111: multout[48] <= 18'sd918;
5'b01001: multout[48] <= 18'sd1223;
5'b01110: multout[48] <= 18'sd1836;
default: multout[48] <= 18'sd0;
endcase

casez(sum_level_1[49])
5'b10000: multout[49] <= 18'sd9482;
5'b10101: multout[49] <= 18'sd6321;
5'b01000: multout[49] <= 18'sd4741;
5'bz1010: multout[49] <= 18'sd3160;
5'b01101: multout[49] <= 18'sd1580;
5'b00000: multout[49] <= 18'sd0;
5'b00010: multout[49] <= -18'sd1581;
5'bz0100: multout[49] <= -18'sd3161;
5'b00111: multout[49] <= -18'sd4741;
5'b01001: multout[49] <= -18'sd6322;
5'b01110: multout[49] <= -18'sd9482;
default: multout[49] <= 18'sd0;
endcase

casez(sum_level_1[50])
5'b10000: multout[50] <= 18'sd18000;
5'b10101: multout[50] <= 18'sd11999;
5'b01000: multout[50] <= 18'sd9000;
5'bz1010: multout[50] <= 18'sd6000;
5'b01101: multout[50] <= 18'sd2999;
5'b00000: multout[50] <= 18'sd0;
5'b00010: multout[50] <= -18'sd3000;
5'bz0100: multout[50] <= -18'sd6001;
5'b00111: multout[50] <= -18'sd9000;
5'b01001: multout[50] <= -18'sd12000;
5'b01110: multout[50] <= -18'sd18000;
default: multout[50] <= 18'sd0;
endcase

casez(sum_level_1[51])
5'b10000: multout[51] <= 18'sd16744;
5'b10101: multout[51] <= 18'sd11162;
5'b01000: multout[51] <= 18'sd8372;
5'bz1010: multout[51] <= 18'sd5581;
5'b01101: multout[51] <= 18'sd2790;
5'b00000: multout[51] <= 18'sd0;
5'b00010: multout[51] <= -18'sd2791;
5'bz0100: multout[51] <= -18'sd5582;
5'b00111: multout[51] <= -18'sd8372;
5'b01001: multout[51] <= -18'sd11163;
5'b01110: multout[51] <= -18'sd16744;
default: multout[51] <= 18'sd0;
endcase

casez(sum_level_1[52])
5'b10000: multout[52] <= 18'sd1892;
5'b10101: multout[52] <= 18'sd1261;
5'b01000: multout[52] <= 18'sd946;
5'bz1010: multout[52] <= 18'sd630;
5'b01101: multout[52] <= 18'sd315;
5'b00000: multout[52] <= 18'sd0;
5'b00010: multout[52] <= -18'sd316;
5'bz0100: multout[52] <= -18'sd631;
5'b00111: multout[52] <= -18'sd946;
5'b01001: multout[52] <= -18'sd1262;
5'b01110: multout[52] <= -18'sd1892;
default: multout[52] <= 18'sd0;
endcase

casez(sum_level_1[53])
5'b10000: multout[53] <= -18'sd24688;
5'b10101: multout[53] <= -18'sd16459;
5'b01000: multout[53] <= -18'sd12344;
5'bz1010: multout[53] <= -18'sd8230;
5'b01101: multout[53] <= -18'sd4115;
5'b00000: multout[53] <= 18'sd0;
5'b00010: multout[53] <= 18'sd4114;
5'bz0100: multout[53] <= 18'sd8229;
5'b00111: multout[53] <= 18'sd12344;
5'b01001: multout[53] <= 18'sd16458;
5'b01110: multout[53] <= 18'sd24688;
default: multout[53] <= 18'sd0;
endcase

casez(sum_level_1[54])
5'b10000: multout[54] <= -18'sd55448;
5'b10101: multout[54] <= -18'sd36966;
5'b01000: multout[54] <= -18'sd27724;
5'bz1010: multout[54] <= -18'sd18483;
5'b01101: multout[54] <= -18'sd9242;
5'b00000: multout[54] <= 18'sd0;
5'b00010: multout[54] <= 18'sd9241;
5'bz0100: multout[54] <= 18'sd18482;
5'b00111: multout[54] <= 18'sd27724;
5'b01001: multout[54] <= 18'sd36965;
5'b01110: multout[54] <= 18'sd55448;
default: multout[54] <= 18'sd0;
endcase

casez(sum_level_1[55])
5'b10000: multout[55] <= -18'sd79960;
5'b10101: multout[55] <= -18'sd53307;
5'b01000: multout[55] <= -18'sd39980;
5'bz1010: multout[55] <= -18'sd26654;
5'b01101: multout[55] <= -18'sd13327;
5'b00000: multout[55] <= 18'sd0;
5'b00010: multout[55] <= 18'sd13326;
5'bz0100: multout[55] <= 18'sd26653;
5'b00111: multout[55] <= 18'sd39980;
5'b01001: multout[55] <= 18'sd53306;
5'b01110: multout[55] <= 18'sd79960;
default: multout[55] <= 18'sd0;
endcase

casez(sum_level_1[56])
5'b10000: multout[56] <= -18'sd89296;
5'b10101: multout[56] <= -18'sd59531;
5'b01000: multout[56] <= -18'sd44648;
5'bz1010: multout[56] <= -18'sd29766;
5'b01101: multout[56] <= -18'sd14883;
5'b00000: multout[56] <= 18'sd0;
5'b00010: multout[56] <= 18'sd14882;
5'bz0100: multout[56] <= 18'sd29765;
5'b00111: multout[56] <= 18'sd44648;
5'b01001: multout[56] <= 18'sd59530;
5'b01110: multout[56] <= 18'sd89296;
default: multout[56] <= 18'sd0;
endcase

end
endmodule