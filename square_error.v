module square_error(input clk,
	input reset,
	input clk_en,
    input clear_accum,
	input signed [17:0] error,
	output reg signed [38:0] sq_err_out
);
reg signed [53:0] err_acc;
reg signed [35:0] sq_err;

// pipelined multiplier
always @ (posedge clk)
// if(reset)
// sq_err <= 36'b0;
// else 
if(clk_en)
    sq_err <= error*error;

// error accumulator logic
always @ (posedge clk)
if(reset)
    err_acc <= sq_err[34:0];
else if(clear_accum)
    err_acc <= sq_err[34:0];
else if(clk_en)
    err_acc <= err_acc + sq_err[34:0];

// final accumulated reg (output might need to be more than 18bit)
always@ (posedge clk)
// if(reset)
//     sq_err_out <= 18'sd0;
// else 
if(clear_accum)
    sq_err_out <= err_acc[53:15]; //20s19



endmodule