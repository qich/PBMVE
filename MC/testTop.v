`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:56:23 08/03/2016
// Design Name:   top
// Module Name:   E:/MC/testTop.v
// Project Name:  MC
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

module testTop;

	// Inputs
	reg CLK;
	reg reset;
	reg [7:0] height;
	reg [7:0] width;
	reg MV_fin;

	// Outputs
	wire LF_conceal;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.reset(reset),
		.CLK(CLK), 
		.height(height), 
		.width(width), 
		.MV_fin(MV_fin), 
		.LF_conceal(LF_conceal)
	);

	initial begin
		// Initialize Inputs
		CLK = 0;
		height = 2;
		width = 2;
		MV_fin = 0;
		reset = 1;

		// Wait 100 ns for global reset to finish
		#10;
		reset = 0;
		#100;
		MV_fin = 1;
		
        
		// Add stimulus here

	end
	always #10 CLK = ~CLK;
      
endmodule

