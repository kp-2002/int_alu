module int_adder #(parameter DATA_WIDTH=32)
	//data width of the adder
       (input                       clk,
       	//clock
       	input                       rst_n,
	//active low reset
	input                       en,
	//active high enable
       	input      [DATA_WIDTH-1:0] data_a,
	//data port
	input      [DATA_WIDTH-1:0] data_b,
	//other data port
	input                       carry_in,
	//carry in
	output reg [DATA_WIDTH-1:0] sum,
	//result of addition
	output reg                  carry_out
	//carry out
	);

	wire [DATA_WIDTH-1:0] sum_t;
	wire [DATA_WIDTH  :0] carry_intrnl;
	wire                  carry_out_t;

	assign carry_intrnl[0] = 1'b0;
	assign carry_out_t     = carry_intrnl[DATA_WIDTH];

	genvar i;

	generate
		for(i=0;i<DATA_WIDTH;i=i+1) begin
			fa i_fa(
				.a(data_a[i]),
				.b(data_b[i]),
				.carry_in(carry_intrnl[i]),
				.sum(sum_t[i]),
				.carry_out(carry_intrnl[i+1]));
		end
	endgenerate

	always @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			sum       <= 32'b0;
			carry_out <= 1'b0;
		end
		else if(en) begin
			sum       <= sum_t;
			carry_out <= carry_out_t;
		end
	end

endmodule
