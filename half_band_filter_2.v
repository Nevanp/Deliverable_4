module half_band_filter_2(
        input clk,
		input reset,
		input signed [17:0] x_in,
		output reg signed [17:0] y 
);
reg signed [17:0] b,b1;
reg signed [17:0] x[8:0];
reg signed [35:0] mult_out[1:0];
reg signed [17:0] sum_1, sum_2;
integer i;



always @ (posedge clk)
x[0] <= {x_in[17],x_in[17:1]};

always @ (posedge clk)
for(i = 1; i < 9; i = i +1)
x[i]<= x[i-1];

always @ *
sum_1 <= x[1]+x[7];

always @ *
sum_2 <= x[3]+x[5];



always @ *
mult_out[0] <= sum_2*b1;

always @ *
mult_out[1] <= sum_1*b;


always @ *
b <= -18'sd16941;

always @ *
b1 <= 18'sd105834;




always @ (posedge clk)
y <= mult_out[1][35:18] + mult_out[0][35:18] + $signed({x[4][17],x[4][17:1]})+$signed({{3{x[4][17]}},x[4][17:3]})+$signed({{4{x[4][17]}},x[4][17:4]});






endmodule