module mapper_power(input clk,
	input reset,
	input clk_en,
    input clear_accum,
	input signed [17:0] decision_var,
    output reg signed [17:0] mapper_power,
	output reg signed [35:0] ref_level
);

// setup inter signals
reg signed [17:0] signal_power;
reg signed [36:0] accum_out,power_acc;
reg signed [35:0] sq_power;
reg signed [35:0] scale_mult;

// take abs of input
always @ *
if(decision_var[17])
    signal_power <= -decision_var;
else
    signal_power <= decision_var;

// square accum output
always @ (posedge clk)
if(clear_accum)
sq_power <= ave_mult*ave_mult;// Since squaring 2s16 -> 4s32

// multiply sq_power by 1.25 done with addition via bit shift
always @ (*)
scale_mult <= sq_power+$signed({{2{sq_power[35]}},sq_power[35:2]});

// output scale mult
always @ *
mapper_power <= scale_mult;//now a 4s32 number so divide by 2^32 ** divide by 2 again since what is going in is half scale



// power accumulator logic
always @ (posedge clk)
if(reset)
    power_acc <= signal_power;
else if(clear_accum)
    power_acc <= signal_power;
else if(clk_en)
    power_acc <= power_acc + signal_power;

// final accumulated reg (output might need to be more than 18bit)
always@ (posedge clk)
if(clear_accum)
    accum_out <= power_acc;


// Find ref level
reg signed [17:0] ave_mult;
always @ (posedge clk)
ave_mult <= {1'b0,accum_out[36:20]};// sum abs y * 1/N_samples

// send ref level out
always @ (posedge clk)
if(clear_accum)
//begin
//if(ave_mult > 0)
ref_level <= ave_mult[17:0]; // get 2s16 average should be ~2b
//else
//ref_level <= -ave_mult;
//end


endmodule