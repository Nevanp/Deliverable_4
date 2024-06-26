module mer_test(input clk,
input clk_50,
	input [3:0] sw,
	input reset,
	input sym_clk_en,
    input smp_clk_en,
    input clk_int,
    input signed [17:0] ref_level,MER_val,dec_var,
    output reg sym_correct,sym_error, //clear_accum,
    output reg [1:0] delayed_input,slice,
	output reg signed [17:0] error,map_out
);
// Interm signals

reg signed  [17:0] inter_error;
wire signed [17:0] out_map_out;
reg [1:0] delayed_in;
wire [1:0] slice_out;
reg signed [17:0] x_in,decision_var,input_to_mapper;
reg signed [17:0] x_input;
reg sym_compare;

// For testing
// always @ (*)
// dec_var <= x_input;


always @ *
delayed_input <= delayed_in;

always @ (*)
decision_var <= dec_var;

parameter DELAY_VAR = 2'd2;

reg signed [17:0] mapper_delay[DELAY_VAR:0];
always @ (posedge clk)
if(smp_clk_en)
mapper_delay[0] <= input_to_mapper;

integer i;	

always @ (posedge clk)
if(sym_clk_en)
for(i=1; i<=DELAY_VAR;i=i+1)
mapper_delay[i] <= mapper_delay[i-1];


always @ (posedge clk)
if(sym_clk_en)
delayed_in <= mapper_delay[DELAY_VAR];
// Input mapper code



 
// error output

always @ *
map_out <= out_map_out;

always @ *
inter_error <= dec_var-out_map_out;

always @ (posedge clk)
if(sym_clk_en)
error <= inter_error;

// Detection Correction Comparison
always @ *
if (reset)
    sym_compare <= 1'b1;
else if (delayed_in == slice_out)
    sym_compare <= 1'b1;
else
    sym_compare <= 1'b0;


always @ (posedge clk)
if (sym_clk_en)
    sym_correct <= sym_compare;

always @ (posedge clk)
if (sym_clk_en)
    sym_error <= ~sym_compare;


// wire accum_clear;

// always @ *
// clear_accum <= accum_clear;
// // Instantiate LFSR
// lfsr SUT(
//     .clk(clk),
//     .clk_en(smp_clk_en),
//     .reset(reset),
//     .clear_accum(accum_clear),
//     .y(lfsr_test)
// );

// // SUT instantiate
// wire signed [17:0] ideal_err,ideal_dec;
// comm_SUT SUT_2(
//     .clk(clk),
//     .clk_50(clk_50),
//     .clk_int(clk_int),
//     .clear_accum(clear_accum),
// 	 .sw(sw),
//     .sym_clk(sym_clk_en),
// 	 .sam_clk(smp_clk_en),
//     .reset(reset),
//     .data_in(x_input),
//     .data_out(dec_var)
// );

slicer SLIC(
    .ref_level(ref_level),
    .dec_var(dec_var),
    .slice_out(slice_out),
    .out_map_out(out_map_out)
);

endmodule