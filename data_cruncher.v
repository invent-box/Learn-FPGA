`timescale 1ns / 1ps
module data_cruncher(
	input wire clk,
	input wire rst
  );

	reg [7:0] counter, timer;
	reg write_enable, doing_calculations;
	reg [7:0] addr, w_data;
	wire [7:0] r_data;

	sram #(.ADDR_WIDTH(8), .DATA_WIDTH(8), .DEPTH(256)) mem (
		.clk(clk), 
		.i_addr(addr), 
		.i_write(write_enable), 
		.i_data(w_data),
		.o_data(r_data)
	);
	
	// runs every clock cycle
	always @(posedge clk) begin
		if (rst) begin
			counter <= 0;
			timer <= 0;
			write_enable <= 0;
			doing_calculations <= 0;
			addr <= 0;
			w_data <= 0;
		end else begin
			// can finish in one clock cycle
			counter <= counter + 1;
			if (timer > 0) timer = timer - 1;
		end
	end
	
	always @(posedge clk) begin
		if (!rst) begin
			// needs more than one clock cycle to finish
			timer <= 4;
			doing_calculations <= 1;
			
			wait (timer == 1) begin
				addr <= counter;
				w_data <= counter;
				write_enable <= 1;
			end
			
			wait (timer == 0) begin
				write_enable <= 0;
				doing_calculations <= 0;
			end
		end
	end

endmodule
