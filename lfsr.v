module lfsr(
    input clk,
    input clk_en,
    input reset,
    output reg clear_accum,
    output reg signed [21:0] y
);

reg unsigned [21:0] lfsr;
reg unsigned xor_out;

always @ *
    xor_out = ((lfsr[21]^lfsr[14])^lfsr[13])^lfsr[7];


always @ (posedge clk)
    if(reset)
    lfsr[0] <= 1'b1;
    else if (clk_en)
    lfsr[0] <= xor_out;

always @ (posedge clk)
    if(reset)
    lfsr [21:1] = 21'h0;
    else if (clk_en)
        lfsr[21:1] <= lfsr[20:0];

always @ (*)
if(clk_en)
begin
  if(lfsr == 22'h1)
    clear_accum <= 1'b1;
end
else
    clear_accum <= 1'b0;


always @ *
    y <= lfsr;


endmodule