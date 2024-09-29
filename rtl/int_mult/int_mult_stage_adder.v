module int_mult_stage_adder #(
	parameter         DATA_WIDTH = 32,
	//data width of the adder
	parameter          STAGE_NUM = 0,
	//the stage of the multiplier the adder is used in
	parameter  INPUT_CARRY_WIDTH = 2**(STAGE_NUM),
	//the data width of the input carries fed to the adder
	parameter OUTPUT_CARRY_WIDTH = 2**(STAGE_NUM+1),
	//the data width of the output carries produced by the adder
	parameter        INPUT_WIDTH = DATA_WIDTH+INPUT_CARRY_WIDTH,
	//the data width of the input fed to the adder including the carries
	parameter       OUTPUT_WIDTH = DATA_WIDTH+OUTPUT_CARRY_WIDTH
	//the data width of the ouput produced by the adder including the carries
	)
       (input                         clk,
       	//clock
       	input                         rst_n,
	//active low reset
	input                         en,
	//active high enable
       	input       [INPUT_WIDTH-1:0] data_a,
	//data port
	input       [INPUT_WIDTH-1:0] data_b,
	//other data port
	output reg [OUTPUT_WIDTH-1:0] sum
	//result of addition
	);

	wire [OUTPUT_WIDTH-1:0] sum_t;
	wire                    carry_out_t;

	int_adder_comb i_int_adder_comb #(.DATA_WIDTH(DATA_WIDTH))
	       (.data_a(data_a[INPUT_WIDTH-1:INPUT_CARRY_WIDTH]),
		.data_b(data_b[DATA_WIDTH-1:0]),
		.carry_in(1'b0),
		.sum(sum_t[DATA_WIDTH-1:INPUT_CARRY_WIDTH]),
		.carry_out(carry_out_t));

	int_carry_adder i_int_carry_adder #(.DATA_WIDTH(DATA_WIDTH))
	       (.data_in(data_b[INPUT_WIDTH-1:DATA_WIDTH]),
		.carry_in(carry_out_t),
		.sum(sum_t[OUTPUT_WIDTH-1:DATA_WIDTH]),
		.carry_out());

	always @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			sum       <= 'b0;
			carry_out <= 1'b0;
		end
		else if(en) begin
			sum       <= sum_t;
			carry_out <= carry_out_t;
		end
	end

	assign sum_t[INPUT_CARRY_WIDTH-1:0] = data_a[INPUT_CARRY_WIDTH-1:0];

endmodule
