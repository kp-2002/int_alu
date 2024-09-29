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

	reg  [2*DATA_WIDTH-1:0] sum_intmd[(DATA_WIDTH/2)-1:0][NUM_STAGES-2:0];

	genvar i,j;

	generate
		for(j=0;j<(DATA_WIDTH-1);j=j+2) begin
			int_mult_first_stage_adder i_int_mult_first_stage_adder #(.DATA_WIDTH(DATA_WIDTH))
			       (.clk(clk),
				.rst_n(rst_n),
				.en(en),
				.data_a({1'b0,(m_cand & m_plier[j])[31:1]}),
				.data_b(m_cand & m_plier[j+1]),
				.sum(sum_intmd[(j/2)][0]));
		end
	endgenerate

	generate
		for(i=1;i<NUM_STAGES;i=i+1) begin
			for(j=1;j<(DATA_WIDTH/(2**i)-1);j=j+2) begin
				int_mult_stage_adder i_int_mult_stage_adder #(
					.DATA_WIDTH(DATA_WIDTH),
					.NUM_STAGE(i),
					.INPUT_CARRY_WIDTH(2**i),
					.OUTPUT_CARRY_WIDTH(2**(i+1)),
					.INPUT_WIDTH(DATA_WIDTH+2**i),
					.OUTPUT_WIDTH(DATA_WIDTH+2**(i+1))
				       (.clk(clk),
					.rst_n(rst_n),
					.en(en),
					.data_a((sum_intmd[j][i-1])[(DATA_WIDTH+2**i):0]),
					.data_b((sum_intmd[j+1][i-1])[(DATA_WIDTH+2**i):0]),
					.sum((sum_intmd[j][i])[(DATA_WIDTH+2**(i+1)):0]);
			end
		end
	endgenerate

endmodule
