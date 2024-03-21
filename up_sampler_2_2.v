module up_sampler_2_2(
    input clk,
	 input sam_clk,
     input int_clk,
     input sym_clk,
	input reset,
	input signed [17:0] x_in,
	output reg signed [17:0] y   
);

reg sampler;
reg counter;


always @ *
    case(counter)
    1'b0: sampler <= 1;
    default: sampler <= 0;
    endcase

always @ (posedge clk)
begin
    if (reset||int_clk)
        counter <= 1'b0;
    else
        counter = counter + 1'b1;
end

always @ *
if(int_clk)
    y <= x_in;
else
y<=18'sd0;

endmodule