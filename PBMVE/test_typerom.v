`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:40:26 07/20/2016
// Design Name:   top
// Module Name:   E:/PBMVE/test_typerom.v
// Project Name:  PBMVE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_typerom;

	// Inputs
	reg enable;
	reg CLK;
	reg reset;
	reg SLowCLK;
	reg [7:0] height;
	reg [7:0] width;
	reg Vector_sig;
	reg [7:0] mv_x;
	reg [7:0] addr_x;
	reg [7:0] mv_y;
	reg [7:0] addr_y;
	reg [5:0] pdi;

	// Outputs
	wire Nxt_block_sig;
	wire MVF_complete_sig;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.enable(enable), 
		.CLK(CLK), 
		.reset(reset), 
		.Slow_clk(SLowCLK), 
		.height(height), 
		.width(width), 
		.Vector_sig(Vector_sig), 
		.mv_x(mv_x), 
		.addr_x(addr_x), 
		.mv_y(mv_y), 
		.addr_y(addr_y), 
		.Nxt_block_sig(Nxt_block_sig), 
		.MVF_complete_sig(MVF_complete_sig)
	);

	initial begin
		// Initialize Inputs
		enable = 0;
		CLK = 0;
		reset = 0;
		SLowCLK = 0;
		height = 5;
		width = 5;
		Vector_sig = 0;
		mv_x = 0;
		addr_x = 0;
		mv_y = 0;
		addr_y = 0;
		pdi = 0;

		// Wait 100 ns for global reset to finish
		#10;
		reset = 1;
		
		#10
		reset = 0;
		enable = 1;
		Vector_sig = 0;
		mv_x = 1;
		addr_x = 1;
		mv_y = 1;
		addr_y = 1;
		
		#100
		Vector_sig = 1;
		#20
		Vector_sig = 0;
        
		// Add stimulus here

	end
   always #10 CLK = ~CLK;
	always #10 SLowCLK = ~SLowCLK;
endmodule

