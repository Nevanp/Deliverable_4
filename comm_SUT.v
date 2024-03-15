module comm_SUT(
    input clk,
    input clk_50,
    input clear_accum,
	 input [3:0] sw,
    input sym_clk,
    input sam_clk,
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
gs_tx_filter TRANS(
    .clk(clk),
    .clk_en(sam_clk),
    //.reset(reset),
    .x_in(data_up),
    .y(tx_data1)
);

reg signed [17:0] tx;

always @ *
case(sw[3])
1'b0: tx <= tx_data1;
1'b1: tx <= tx_data;
endcase


rx_red2 RECEIVER(
    .clk(clk),
    .clk_en(sam_clk),
	 .sym_clk(sym_clk),
    .reset(reset),
    .x_in(tx),
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