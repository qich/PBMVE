`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:33:23 07/20/2016 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top(
    input enable,
    input CLK,
    input reset,
    input Slow_clk,
    input [7:0]height,
    input [7:0]width,
    input Vector_sig,
    input [7:0]mv_x,
    input [7:0]addr_x,
    input [7:0]mv_y,
    input [7:0]addr_y,
    output Nxt_block_sig,
	 output MVF_complete_sig
	 
	 
    );
wire [1:0]data_type;
wire [15:0]Tindex;

wire [5:0]pdi;
wire [15:0]index;
wire we;
wire [8:0]datax_out;
wire [8:0]datay_out;
wire [5:0]pdo;

TypeRom trom (
  .clka(Slow_clk), // input clka
  .addra(Tindex), // input [15 : 0] addra
  .douta(data_type) // output [1 : 0] douta
);
Reconstructor recon(
	.enable(enable),
	.CLK(CLK),
	.reset(reset),
	.Slow_clk(Slow_clk),
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
wire [8:0] doutax;
wire [8:0] doutay;
LFMVram ramx (
  .clka(Slow_clk), // input clka
  .wea(we), // input [0 : 0] wea
  .addra(index), // input [15 : 0] addra
  .dina(datax_out), // input [8 : 0] dina
  .douta(doutax) // output [8 : 0] douta
);
LFMVram ramy (
  .clka(Slow_clk), // input clka
  .wea(we), // input [0 : 0] wea
  .addra(index), // input [15 : 0] addra
  .dina(datay_out), // input [8 : 0] dina
  .douta(doutay) // output [8 : 0] douta
);
Pram ramp (
  .clka(Slow_clk), // input clka
  .wea(we), // input [0 : 0] wea
  .addra(index), // input [15 : 0] addra
  .dina(pdo), // input [5 : 0] dina
  .douta(pdi) // output [5 : 0] douta
);
endmodule
