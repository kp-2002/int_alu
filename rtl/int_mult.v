module int_mult #(parameter DATA_WIDTH=32) (
	input      [DATA_WIDTH-1:0] m_plier,
	input      [DATA_WIDTH-1:0] m_cand,
	output reg [DATA_WIDTH-1:0] result
	);

	parameter NUM_STAGES=$clog(DATA_WIDTH);

	genvar i,j;
	generate
		for(i=0;i<DATA_WIDTH/2;i=i+1) begin
			int_adder i_int_adder(
					.data_a(m_cand & m_plier[i]),
					.data_b(m_cand & m_plier[i+1]),
					.result(result_intmd[i][]));

		end
	endgenerate

endmodule
