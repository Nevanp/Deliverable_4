module half_band_filter_1(
        input clk,
        input clk_en,
		input reset,
		input signed [17:0] x_in,
		output reg signed [17:0] y 
);
reg signed [17:0] b;
reg signed [17:0] x[2:0];
reg signed [35:0] mult_out;
reg signed [17:0] sum_1;


always @ (posedge clk)
if(clk_en)
x[0] <= {x_in[17],x_in[17:1]};

always @ (posedge clk)
if(clk_en)
for(i = 1; i < 3; i = i +1)
x[i]<= x[i-1];




always @ *
sum_1 <= x[0]+x[2];

always @ *
mult_out <= sum_1*b;





always @ *
b <= 18'sd716;




always @ (posedge clk)
if(clk_en)
y <= x[2]+mult_out[35:18];






endmodule