`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:36:52 07/19/2016
// Design Name:   top_testMF
// Module Name:   E:/MF/test_mf.v
// Project Name:  MF
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_testMF
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_mf;

	// Inputs
	reg reset;
	reg enable;
	reg CLK;
	reg Slow_clk;
	reg Nxt_block_sig;
	reg [7:0] height;
	reg [7:0] width;

	// Outputs
	wire [7:0] addr_x0;
	wire [7:0] addr_y0;
	wire [7:0] gdata;
	wire Gvector_sig;

	// Instantiate the Unit Under Test (UUT)
	top_testMF uut (
		.reset(reset), 
		.enable(enable), 
		.CLK(CLK), 
		.Slow_clk(Slow_clk), 
		.Nxt_block_sig(Nxt_block_sig), 
		.height(height), 
		.width(width), 
		.addr_x0(addr_x0), 
		.addr_y0(addr_y0), 
		.gdata(gdata), 
		.Gvector_sig(Gvector_sig)
	);

	initial begin
		// Initialize Inputs
		reset = 0;
		enable = 0;
		CLK = 0;
		Slow_clk = 0;
		Nxt_block_sig = 0;
		height = 3;
		width = 3;

		// Wait 100 ns for global reset to finish
		#100;
		reset = 1;
		Nxt_block_sig = 1;
		
		#100;
		reset = 0;
		enable = 1;
        
		// Add stimulus here

	end
	
	always #10 CLK = ~CLK;
	always #10 Slow_clk = ~Slow_clk;
      
endmodule

