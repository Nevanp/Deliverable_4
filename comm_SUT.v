module comm_SUT(
    input clk,
    input clk_50,
    input clear_accum,
	 input [3:0] sw,
    input sym_clk,
    input sam_clk,
    input clk_int,
    input signed [17:0] data_in,
    input reset,
    output reg signed [17:0] data_out
);
wire signed [17:0] data_up, tx_data, rx_data, data_down, tx_data1;
reg signed [17:0] delayed_rx1, delayed_rx2,delayed_rx3,delayed_rx4, rx;
always @ *
data_out <= data_down;

always @ (posedge clk)
if(sam_clk)
delayed_rx1 <= rx_data;

always @ (posedge clk)
if(sam_clk)
delayed_rx2 <= delayed_rx1;

always @ (posedge clk)
if(sam_clk)
delayed_rx3 <= delayed_rx2;

always @ (posedge clk)
if(sam_clk)
delayed_rx4 <= delayed_rx3;

always @ *
case(sw[2:0])
2'd0: rx <= delayed_rx1;
2'd1:rx <= delayed_rx2;
2'd2:rx <= delayed_rx3;
2'd3: rx <= delayed_rx4;
3'd4: rx <= rx_data;
endcase

// instantiate Parts of SUT
up_sampler_4 UPPER(
    .clk(clk),
        .sam_clk(sam_clk),
    .sym_clk(sym_clk),
    .reset(reset),
    .x_in(data_in),
    .y(data_up)
);

tx_practical TRANSMITTER(
    .clk(clk),
    .sam_clk(sam_clk),
    //.reset(reset),
    .x_in(data_up),
    .y(tx_data)
);



wire signed [17:0] up1,half1,up2,half2,down1,half3,down2,half4;

up_sampler_2_1 UP1(
    .clk(clk),
    .sam_clk(sam_clk),
    .int_clk(clk_int),
    .reset(reset),
    .x_in(tx_data),
    .y(up1)
);

half_band_filter_1 HALF1(
    .clk(clk),
    .clk_en(clk_int),
    .reset(reset),
    .x_in(up1),
    .y(half1)
);

up_sampler_2_2 UP2(
        .clk(clk),
    .sam_clk(sam_clk),
    .int_clk(clk_int),
    .reset(reset),
    .x_in(half1),
    .y(up2)
);

half_band_filter_2 HALF2(
    .clk(clk),
    .reset(reset),
    .x_in(up2),
    .y(half2)
);

half_band_filter_2 HALF3(
    .clk(clk),
    .reset(reset),
    .x_in(half2),
    .y(half3)
);

down_sampler_2_1 DOWN1(
    .clk(clk),
    .reset(reset),
    .clk_en(clk_int),
    .x_in(half3),
    .y(down1)
);

half_band_filter_1 HALF4(
    .clk(clk),
    .clk_en(clk_int),
    .reset(reset),
    .x_in(down1),
    .y(half4)
);
reg signed [17:0] half4_delay;
always @ (posedge clk)
if(clk_int)
half4_delay <= half4;


down_sampler_2_2 DOWN2(
    .clk(clk),
    .reset(reset),
    .clk_en(sam_clk),
    .x_in(half4_delay),
    .y(down2)
);



rx_red2 RECEIVER(
    .clk(clk),
    .clk_en(sam_clk),
	 .sym_clk(sym_clk),
    .reset(reset),
    .x_in(down2),
    .y(rx_data)
);


down_sampler_4 DOWNER(
    .clk(clk),
    .clk_en(sym_clk),
    //.reset(reset),
    .x_in(rx),
    .y(data_down)
);


endmodule