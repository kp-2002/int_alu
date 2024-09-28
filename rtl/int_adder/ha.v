module ha(
	input  a,
	input  carry_in,
	output sum,
	output carry_out);

	assign sum       = a ^ carry_in;
	assign carry_out = a & carry_in;

endmodule
