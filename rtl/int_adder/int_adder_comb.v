module int_adder_comb #(parameter DATA_WIDTH=32)
	//data width of the adder
       (input      [DATA_WIDTH-1:0] data_a,
	//data port
	input      [DATA_WIDTH-1:0] data_b,
	//other data port
	input                       carry_in,
	//carry in
	output     [DATA_WIDTH-1:0] sum,
	//result of addition
	output                      carry_out
	//carry out
	);

	wire [DATA_WIDTH  :0] carry_intrnl;

	genvar i;

	generate
		for(i=0;i<DATA_WIDTH;i=i+1) begin
			fa i_fa(
				.a(data_a[i]),
				.b(data_b[i]),
				.carry_in(carry_intrnl[i]),
				.sum(sum[i]),
				.carry_out(carry_intrnl[i+1]));
		end
	endgenerate

	assign carry_intrnl[0] = 1'b0;
	assign carry_out       = carry_intrnl[DATA_WIDTH];

endmodule
