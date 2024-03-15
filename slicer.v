module slicer(
    input signed [17:0] ref_level,
    input signed [17:0] dec_var,
    output reg [1:0] slice_out,
    output reg signed  [17:0] out_map_out
);
// Slicer


// Output Mapper
always @ *
if(dec_var >= ref_level)
    slice_out <= 2'd2;
else if (dec_var <= (-ref_level))
    slice_out <= 2'd0;
else if (dec_var <= 18'sd0)
    slice_out <= 2'd1;
else if (dec_var > 18'sd0)
    slice_out <= 2'd3;

// find mapper values
reg signed [17:0] b,neg_b,three_b,neg_three_b;

always @ *
b <= $signed({ref_level[17],ref_level[17:1]});
always @ *
neg_b <= -$signed({ref_level[17],ref_level[17:1]});
always @ *
three_b <= ref_level+$signed({ref_level[17],ref_level[17:1]});
always @ *
neg_three_b <= -(ref_level+$signed({ref_level[17],ref_level[17:1]}));


// map
always @ (*)
case(slice_out)
2'b00: out_map_out <= neg_three_b;
2'b01: out_map_out <= neg_b;
2'b11: out_map_out <= b;
2'b10: out_map_out <= three_b;
endcase
endmodule