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

	reg  [DATA_WIDTH-1:0] result_intmd[(DATA_WIDTH/2)-1:0][NUM_STAGES-1:0];
	wire                  carry_intmd[(DATA_WIDTH/2)-1:0][NUM_STAGES-1:0];

	genvar i,j;

	int_adder i_first_stage_left_int_adder(
				.clk(clk),
				.rst_n(rst_n),
				.en(en),
				.carry_in(1'b0),
				.data_a({1'b0,(m_cand & m_plier[0])[31:1]}),
				.data_b(m_cand & m_plier[1]),
				.result(result_intmd[0][0]),
				.carry_out());

	generate
		for(j=2;j<(DATA_WIDTH-3);j=j+2) begin
			int_adder i_first_stage_int_adder(
				.clk(clk),
				.rst_n(rst_n),
				.en(en),
				.carry_in(),
				.data_a(m_cand & m_plier[j]),
				.data_b(m_cand & m_plier[j+1]),
				.result(result_intmd[(j/2)][0]),
				.carry_out());
		end
	endgenerate

	int_adder i_first_stage_right_int_adder(
			.clk(clk),
			.rst_n(rst_n),
			.en(en),
			.carry_in(),
			.data_a(m_cand & m_plier[(DATA_WIDTH-2)]),
			.data_b({(m_cand & m_plier[(DATA_WIDTH-1)])[30:0],1'b0}),
			.result(result_intmd[((DATA_WIDTH/2)-1)][0]),
			.carry_out());

	generate
		for(i=1;i<NUM_STAGES-1;i=i+1) begin
			int_adder i_intmd_stage_left_int_adder(
					.clk(clk),
					.rst_n(rst_n),
					.en(en),
					.carry_in(),
					.data_a({1'b0,(result_intmd[j][i-1])[31:1]}),
					.data_b(result_intmd[j+1][i-1]),
					.result(result_intmd[j][i]),
					.carry_out());
			for(j=1;j<(DATA_WIDTH/(2**i)-1);j=j+2) begin
				int_adder i_intmd_stage_int_adder(
					.clk(clk),
					.rst_n(rst_n),
					.en(en),
					.carry_in(),
					.data_a(result_intmd[j][i-1]),
					.data_b(result_intmd[j+1][i-1]),
					.result(result_intmd[j][i]),
					.carry_out());
			end
			int_adder i_intmd_stage_right_int_adder(
					.clk(clk),
					.rst_n(rst_n),
					.en(en),
					.carry_in(),
					.data_a(result_intmd[j][i-1]),
					.data_b({(result_intmd[j+1][i-1])[30:1],1'b0}),
					.result(result_intmd[j][i]),
					.carry_out());
		end
	endgenerate

	int_adder i_final_stage_int_adder(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.carry_in(),
		.data_a(result_intmd[0][NUM_STAGES-2]),
		.data_b(result_intmd[1][NUM_STAGES-2]),
		.result(result[(3*DATA_WIDTH/2):(DATA_WIDTH/2)]),
		.carry_out());

endmodule
