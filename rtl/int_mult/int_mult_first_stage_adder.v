module int_mult_stage_adder #(
	parameter         DATA_WIDTH = 32,
	//data width of the adder
	parameter        INPUT_WIDTH = DATA_WIDTH,
	//the data width of the input fed to the adder including the carries
	parameter       OUTPUT_WIDTH = DATA_WIDTH+2
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

	int_adder_comb i_int_adder_comb #(.DATA_WIDTH(DATA_WIDTH))
	       (.data_a({1'b0,data_a[DATA_WIDTH-1:1]}),
		.data_b(data_b[DATA_WIDTH-1:0]),
		.carry_in(1'b0),
		.sum(sum_t[OUTPUT_WIDTH-2:1]),
		.carry_out(sum_t[OUTPUT_WIDTH-1]));

	always @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			sum       <= 'b0;
		end
		else if(en) begin
			sum       <= sum_t;
		end
	end

	assign sum_t[0] = data_a[0];

endmodule
