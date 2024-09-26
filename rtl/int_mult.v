module int_mult #(parameter DATA_WIDTH=32) (
	input      [DATA_WIDTH-1:0] m_plier,
	input      [DATA_WIDTH-1:0] m_cand,
	output reg [DATA_WIDTH-1:0] result
	);

	parameter NUM_STAGES=$clog(DATA_WIDTH);

	reg [DATA_WIDTH-1:0] result_intmd[DATA_WIDTH/2-1:0][NUM_STAGES-1:0];

	genvar i,j;

	generate
		for(j=0;j<(DATA_WIDTH/2);j=j+2) begin
			int_adder i_int_adder(
				.data_a(m_cand & m_plier[j]),
				.data_b(m_cand & m_plier[j+1]),
				.result(result_intmd[j][0]));
		end
	endgenerate

	generate
		for(i=1;i<NUM_STAGES;i=i+1) begin
			for(j=0;j<(DATA_WIDTH/(2**i));j=j+2) begin
				int_adder i_int_adder(
					.data_a(result_intmd[j][i-1]),
					.data_b(result_intmd[j+1][i-1]),
					.result(result_intmd[j][i]));
			end
		end
	endgenerate

endmodule
