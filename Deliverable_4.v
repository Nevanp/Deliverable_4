module Deliverable_4(
			input CLOCK_50,
			input [3:0]PHYS_KEY,
			input [3:0]PHYS_SW,
			output reg [22:0] counter
			 );

reg clk, clk_smp,clk_sym,reset,clk_int;
reg [3:0] clk_phase;
wire clear_accum_i,sym_correct_i,sym_error_i,clear_accum_q,sym_correct_q,sym_error_q;
wire signed [17:0] err_i, dec_var_i, map_power_i,ref_level_i,map_out_i,err_q, dec_var_q, map_power_q,ref_level_q,map_out_q;
wire signed [37:0] dc_err_i, dc_err_q;
wire signed [38:0] sq_err_i,sq_err_q;
reg signed [17:0] x_in_i,x_in_q,x_input_i,x_input_q;
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
/// Create input const points
// Instantiate LFSR
wire  [21:0] lfsr_test;
lfsr SUT(
    .clk(clk),
    .clk_en(clk_smp),
    .reset(reset),
    .clear_accum(clear_accum_i),
    .y(lfsr_test)
);
/// Mapper
// create index for input mapper input
reg [3:0] input_to_mapper;
always @ *
input_to_mapper <= lfsr_test[3:0];
// Mapper i
always @ (*)
case(input_to_mapper[1:0])
2'b00: x_in <= -18'sd131072;
2'b01: x_in <= -18'sd43691;
2'b11: x_in <= 18'sd43690;
2'b10: x_in <= 18'sd131071;
endcase
// Mapper q
always @ (*)
case(input_to_mapper[3:2])
2'b00: x_in <= -18'sd131072;
2'b01: x_in <= -18'sd43691;
2'b11: x_in <= 18'sd43690;
2'b10: x_in <= 18'sd131071;
endcase

always @ (posedge clk)
if (clk_smp)
	x_input_i <= x_in_i;

always @ (posedge clk)
if (clk_smp)
	x_input_q <= x_in_q;


wire signed [17:0] tx_out_i,tx_out_q;

///iTX
i_tx TXI(
    .clk(clk),
    .clk_50(clk_50),
    .clk_int(clk_int),
    .clear_accum(clear_accum_i),
	 .sw(sw),
    .sym_clk(clk_sym),
	 .sam_clk(clk_smp),
    .reset(reset),
    .data_in(x_input_i),
    .data_out(tx_out_i)
);

///qTX
q_tx TXQ(
    .clk(clk),
    .clk_50(clk_50),
    .clk_int(clk_int),
    .clear_accum(clear_accum_i),
	 .sw(sw),
    .sym_clk(clk_sym),
	 .sam_clk(clk_smp),
    .reset(reset),
    .data_in(x_input_q),
    .data_out(tx_out_q)
);
/// NCO Deal
reg signed [17:0] upconv_out;
reg [1:0] up_counter;
always @ (posedge clk)
if(reset||clear_accum_i)
up_counter <= 1'b0;
else
up_counter <= up_counter + 1'b1;


always @ *
case(up_counter)
2'd0: upconv_out <= tx_out_i;
2'd1: upconv_out <= -tx_out_q;
2'd2: upconv_out <= -tx_out_i;
2'd3: upconv_out <= tx_out_q;
endcase

///Channel

///iRX
i_rx RXI(
    .clk(clk),
    .clk_50(clk_50),
    .clk_int(clk_int),
    .clear_accum(clear_accum_i),
	 .sw(sw),
    .sym_clk(clk_sym),
	 .sam_clk(clk_smp),
    .reset(reset),
    .data_in(x_input),
    .data_out(dec_var_i)
);
///qRX
q_rx RXQ(
    .clk(clk),
    .clk_50(clk_50),
    .clk_int(clk_int),
    .clear_accum(clear_accum_i),
	 .sw(sw),
    .sym_clk(clk_sym),
	 .sam_clk(clk_smp),
    .reset(reset),
    .data_in(x_input),
    .data_out(dec_var_q)
);



// MER Circuit
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

// mer/slicer circuits
wire [1:0] slicer_out_i,slicer_out_q;

mer_test MER_I(.clk(clk),
	.clk_50(CLOCK_50),
	.sw(PHYS_SW),
	.reset(reset),
	.sym_clk_en(clk_sym),
    .smp_clk_en(clk_smp),
	.clk_int(clk_int),
    .ref_level(ref_level_i),
	//.MER_val(MER_val),
    .sym_correct(sym_correct_i),
	.sym_error(sym_error_i),
	.clear_accum(clear_accum_i),
	.error(err_i),
	.dec_var(dec_var_i),
	.slice(slicer_out_i),
	.map_out(map_out_i)
);
mer_test MER_Q(.clk(clk),
	.clk_50(CLOCK_50),
	.sw(PHYS_SW),
	.reset(reset),
	.sym_clk_en(clk_sym),
    .smp_clk_en(clk_smp),
	.clk_int(clk_int),
    .ref_level(ref_level_q),
	//.MER_val(MER_val),
    .sym_correct(sym_correct_q),
	.sym_error(sym_error_q),
	.clear_accum(clear_accum_i),
	.error(err_q),
	.dec_var(dec_var_q),
	.slice(slicer_out_q),
	.map_out(map_out_q)
);


// // Q-channel
// square_error SQERR_Q(.clk(clk),
// 	.reset(reset),
// 	.clk_en(clk_sym),
//     .clear_accum(clear_accum_q),
// 	.error(err_q),
// 	.sq_err_out(sq_err_q)
// );
// dc_error DCERR_Q(.clk(clk),
// 	.reset(reset),
// 	.clk_en(clk_sym),
//     .clear_accum(clear_accum_q),
// 	.error(err_q),
// 	.err_out(dc_err_q)
// );

// mapper_power MAPPOW_Q(.clk(clk),
// 	.reset(reset),
// 	.clk_en(clk_sym),
//     .clear_accum(clear_accum_q),
// 	.decision_var(dec_var_q),
//     .mapper_power(map_power_q),
// 	.ref_level(ref_level_q)
// );

// mer_test #(.lfsr_taps(3)) MER_Q(.clk(clk),
// 	.reset(reset),
// 	.sym_clk_en(clk_sym),
//     .smp_clk_en(clk_smp),
//     .ref_level(ref_level_q),
// 	.MER_val(MER_val),
//     .sym_correct(sym_correct_q),
// 	.sym_error(sym_error_q),
// 	.clear_accum(clear_accum_q),
// 	.error(err_q),
// 	.decision_var(dec_var_q),
// 	.map_out(map_out_q)
// );


endmodule