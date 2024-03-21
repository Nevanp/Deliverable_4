module half_band_filter_1(
        input clk,
        input clk_en,
		input reset,
		input signed [17:0] x_in,
		output reg signed [17:0] y 
);
reg signed [17:0] b,b1;
reg signed [17:0] x[8:0];
reg signed [35:0] mult_out,mult_acc;
reg signed [17:0] sum_1, sum_2,mult_in,mult_val;
reg count;
integer i;
always @ (posedge clk)
if(reset||clk_en)
count <= 1'b1;
else
count <= count + 1'b1;



always @ (posedge clk)
if(clk_en)
x[0] <= {x_in[17],x_in[17:1]};

always @ (posedge clk)
if(clk_en)
for(i = 1; i < 9; i = i +1)
x[i]<= x[i-1];

always @ *
sum_1 <= x[1]+x[7];

always @ *
sum_2 <= x[3]+x[5];

always @ *
case(count)
1'b0: mult_in <= sum_1;
1'b1: mult_in <= sum_2;
endcase

always @ *
case(count)
1'b0: mult_val <= b;
1'b1: mult_val <= b1;
endcase


always @ (posedge clk)
mult_out <= mult_in*mult_val;

always @ (posedge clk)
if(clk_en)
mult_acc <= mult_out;
else
mult_acc <= mult_acc + mult_out;


always @ *
b <= -18'sd12940;

always @ *
b1 <= 18'sd77324;

reg signed [17:0] peak_delay;
always @ (posedge clk)
peak_delay <= x[5];

always @ (posedge clk)
if(clk_en)
y <= mult_acc[35:18] + {peak_delay[17],peak_delay[17:1]};






endmodule