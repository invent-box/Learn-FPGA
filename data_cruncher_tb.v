`timescale 1ns / 1ps
module data_cruncher_tb(
    );

	reg clk, rst;
	
	data_cruncher DUT (
		clk,
		rst
	);
	
	initial begin
		clk = 1'b0;
		rst = 1'b1;
		repeat(4) #10 clk = ~clk;
		rst = 1'b0;
		
		repeat(20) #10 clk = ~clk;  // timescale is 1ns, so #10 provides 100MHz clock
	end

endmodule
