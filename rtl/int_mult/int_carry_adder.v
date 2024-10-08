module int_carry_adder #(parameter DATA_WIDTH=32)
	//data width of the adder
       (input      [DATA_WIDTH-1:0] data_in,
	//data port
	input                       carry_in,
	//carry in
	output     [DATA_WIDTH-1:0] sum,
	//result of addition
	output                      carry_out
	//carry out
	);

	wire [DATA_WIDTH:0] carry_intrnl;

	genvar i;

	generate
		for(i=0;i<DATA_WIDTH;i=i+1) begin
			ha i_ha(
				.a(data_in[i]),
				.carry_in(carry_intrnl[i]),
				.sum(sum[i]),
				.carry_out(carry_intrnl[i+1]));
		end
	endgenerate

	assign carry_intrnl[0] = carry_in;
	assign carry_out       = carry_intrnl[DATA_WIDTH];

endmodule
