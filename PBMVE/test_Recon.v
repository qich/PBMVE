`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:27:02 07/20/2016
// Design Name:   Reconstructor
// Module Name:   E:/PBMVE/test_Recon.v
// Project Name:  PBMVE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Reconstructor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_Recon;

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
	reg [1:0] data_type;
	reg [5:0] pdi;

	// Outputs
	wire Nxt_block_sig;
	wire MVF_complete_sig;
	wire [15:0] Tindex;
	wire [15:0] index;
	wire we;
	wire [8:0] datax_out;
	wire [8:0] datay_out;
	wire [5:0] pdo;
	// Instantiate the Unit Under Test (UUT)
	Reconstructor uut (
		.enable(enable), 
		.CLK(CLK), 
		.reset(reset), 
		.SLowCLK(SLowCLK), 
		.height(height), 
		.width(width), 
		.Vector_sig(Vector_sig), 
		.mv_x(mv_x), 
		.addr_x(addr_x), 
		.mv_y(mv_y), 
		.addr_y(addr_y), 
		.Nxt_block_sig(Nxt_block_sig), 
		.MVF_complete_sig(MVF_complete_sig), 
		.data_type(data_type), 
		.Tindex(Tindex), 
		.pdi(pdi), 
		.index(index), 
		.we(we), 
		.datax_out(datax_out), 
		.datay_out(datay_out), 
		.pdo(pdo)
	);

	initial begin
		// Initialize Inputs
		enable = 0;
		CLK = 0;
		reset = 0;
		SLowCLK = 0;
		height = 0;
		width = 0;
		Vector_sig = 0;
		mv_x = 0;
		addr_x = 0;
		mv_y = 0;
		addr_y = 0;
		data_type = 0;
		pdi = 0;

		// Wait 100 ns for global reset to finish
		#10;
		reset = 1;
		
		#10
		reset = 0;
		enable = 1;
		Vector_sig = 1;
		mv_x = 1;
		addr_x = 1;
		mv_y = 1;
		addr_y = 1;
        
		// Add stimulus here

	end
	
   always #10 CLK = ~CLK;
	
endmodule

