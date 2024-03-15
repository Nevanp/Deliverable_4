module up_sampler_4(
    input clk,
	 input sam_clk,
     input sym_clk,
	input reset,
	input signed [17:0] x_in,
	output reg signed [17:0] y   
);

reg sampler;
reg [1:0] counter;



always @ *
    case(counter)
    2'b00: sampler <= 1;
    default: sampler <= 0;
    endcase

always @ (posedge clk)
begin
    if (reset)
        counter <= 0;
    else
        counter = counter + 1'b1;
end

always @ *
if(sam_clk&&sym_clk)
    y <= x_in;
else
y<=18'sd0;

endmodule