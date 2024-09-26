module int_mult #(parameter DATA_WIDTH=32) 
	//data width of the multiplier can be parameterized
       (input                       clk,
	//clock
	input                       rst_n,
	//active low reset
	input                       en,
	//active high enable
	input      [DATA_WIDTH-1:0] m_plier,
	//multiplier input
	input      [DATA_WIDTH-1:0] m_cand,
	//multiplicand
	output reg [2*DATA_WIDTH-1:0] result
	//result of the multiplication
	);

	parameter NUM_STAGES=$clog(DATA_WIDTH);
	//number of stages in the multiplier

	reg [DATA_WIDTH-1:0] result_intmd[DATA_WIDTH/2-1:0][NUM_STAGES-1:0];

	genvar i,j;

	generate
		for(j=0;j<(DATA_WIDTH/2);j=j+2) begin
			int_adder i_int_adder(
				.clk(clk),
				.rst_n(rst_n),
				.en(en),
				.carry_in(),
				.data_a(m_cand & m_plier[j]),
				.data_b(m_cand & m_plier[j+1]),
				.result(result_intmd[j][0])
				.carry_out());
		end
	endgenerate

	generate
		for(i=1;i<NUM_STAGES-1;i=i+1) begin
			for(j=0;j<(DATA_WIDTH/(2**i));j=j+2) begin
				int_adder i_int_adder(
					.clk(clk),
					.rst_n(rst_n),
					.en(en),
					.carry_in(),
					.data_a(result_intmd[j][i-1]),
					.data_b(result_intmd[j+1][i-1]),
					.result(result_intmd[j][i])
					.carry_out());
			end
		end
	endgenerate

	int_adder i_int_adder_final(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.carry_in(),
		.data_a(result_intmd[0][NUM_STAGES-2]),
		.data_b(result_intmd[1][NUM_STAGES-2]),
		.result(result[(3*DATA_WIDTH/2):(DATA_WIDTH/2)])
		.carry_out());

endmodule
