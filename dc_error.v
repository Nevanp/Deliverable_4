module dc_error(input clk,
	input reset,
	input clk_en,
    input clear_accum,
	input signed [17:0] error,
	output reg signed [37:0] err_out
);

reg signed [37:0] err_acc;


// error accumulator logic
always @ (posedge clk)
if(reset)
    err_acc <= $signed({{20{error[17]}},error});
else if(clear_accum)
    err_acc <= $signed({{20{error[17]}},error});
else if(clk_en)
    err_acc <= err_acc + $signed({{20{error[17]}},error});
else
    err_acc <= err_acc;

// final accumulated reg (output might need to be more than 18bit)
always@ (posedge clk)
if(reset)
    err_out <= 18'sd0;
else if(clear_accum)
    err_out <= err_acc;//21s17
endmodule