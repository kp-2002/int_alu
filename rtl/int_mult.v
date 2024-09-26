module int_mult #(parameter DATA_WIDTH=32) (
	input      [DATA_WIDTH-1:0] data_a,
	input      [DATA_WIDTH-1:0] data_b,
	output reg [DATA_WIDTH-1:0] result
	);

	parameter NUM_STAGES=$clog(DATA_WIDTH);

endmodule
