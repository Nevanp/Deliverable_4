module deliverable_4(
			input CLOCK_50,
			input [3:0]PHYS_KEY,
			input [3:0]PHYS_SW,
			output reg [22:0] counter
			 );

reg clk, clk_smp,clk_sym,reset;
reg [3:0] clk_phase;
wire clear_accum_i,sym_correct_i,sym_error_i,clear_accum_q,sym_correct_q,sym_error_q;
wire signed [17:0] err_i, dec_var_i, map_power_i,ref_level_i,map_out_i,err_q, dec_var_q, map_power_q,ref_level_q,map_out_q;
wire signed [37:0] dc_err_i, dc_err_q;
wire signed [38:0] sq_err_i,sq_err_q;

// reg signed [17:0] x_in;
// reg signed [17:0] x_input;
// wire  [21:0] lfsr_test;
always @ *
if(PHYS_KEY[0])
	reset <= 1'b0;
//else if (clear_accum_i)
	//reset <= 1'b1;
else
	reset <= 1'b1;

always @ (posedge CLOCK_50)
	clk = ~clk;
	// end generatating sampling clock
always @ (posedge clk)

    if (reset)
        counter <= 0;
	else if (clear_accum_i)
		counter <= 0;
    else if (clk_smp)
        counter <= counter +1'b1;


always @ *
case(clk_phase[1:0])
2'b11: clk_smp <= 1'b1;
default: clk_smp <= 1'b0;
endcase


always @ *
case(clk_phase[0])
1'b1: clk_int <= 1'b1;
default: clk_int <= 1'b0;
endcase

always @ *
case(clk_phase)
4'b1111: clk_sym <= 1'b1;
default: clk_sym <= 1'b0;
endcase


always @ (posedge clk)
if(reset)
clk_phase <= 0;
else
clk_phase <= clk_phase +1'b1;


 /* *************************************
     INSTANTIATION SECTION                                          
    ************************************* */
wire [17:0] MER_val;
// in system
//SUT_tester SUT(
//	.source(MER_val),
//	.probe(MER_val)
//);


// I-channel
square_error SQERR_I(.clk(clk),
	.reset(reset),
	.clk_en(clk_sym),
    .clear_accum(clear_accum_i),
	.error(err_i),
	.sq_err_out(sq_err_i)
);
dc_error DCERR_I(.clk(clk),
	.reset(reset),
	.clk_en(clk_sym),
    .clear_accum(clear_accum_i),
	.error(err_i),
	.err_out(dc_err_i)
);

mapper_power MAPPOW_I(.clk(clk),
	.reset(reset),
	.clk_en(clk_sym),
    .clear_accum(clear_accum_i),
	.decision_var(dec_var_i),
    .mapper_power(map_power_i),
	.ref_level(ref_level_i)
);

mer_test #(.lfsr_taps(1)) MER_I(.clk(clk),
	.clk_50(CLOCK_50),
	.sw(PHYS_SW),
	.reset(reset),
	.sym_clk_en(clk_sym),
    .smp_clk_en(clk_smp),
    .ref_level(ref_level_i),
	.MER_val(MER_val),
    .sym_correct(sym_correct_i),
	.sym_error(sym_error_i),
	.clear_accum(clear_accum_i),
	.error(err_i),
	.decision_var(dec_var_i),
	.map_out(map_out_i)
);

// Q-channel
square_error SQERR_Q(.clk(clk),
	.reset(reset),
	.clk_en(clk_sym),
    .clear_accum(clear_accum_q),
	.error(err_q),
	.sq_err_out(sq_err_q)
);
dc_error DCERR_Q(.clk(clk),
	.reset(reset),
	.clk_en(clk_sym),
    .clear_accum(clear_accum_q),
	.error(err_q),
	.err_out(dc_err_q)
);

mapper_power MAPPOW_Q(.clk(clk),
	.reset(reset),
	.clk_en(clk_sym),
    .clear_accum(clear_accum_q),
	.decision_var(dec_var_q),
    .mapper_power(map_power_q),
	.ref_level(ref_level_q)
);

mer_test #(.lfsr_taps(3)) MER_Q(.clk(clk),
	.reset(reset),
	.sym_clk_en(clk_sym),
    .smp_clk_en(clk_smp),
    .ref_level(ref_level_q),
	.MER_val(MER_val),
    .sym_correct(sym_correct_q),
	.sym_error(sym_error_q),
	.clear_accum(clear_accum_q),
	.error(err_q),
	.decision_var(dec_var_q),
	.map_out(map_out_q)
);


endmodule