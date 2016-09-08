`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:50:20 07/19/2016 
// Design Name: 
// Module Name:    top_testMF 
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
module top_testMF(
    input reset,
    input enable,
    input CLK,
    input Slow_clk,
	 input Nxt_block_sig,
    input [7:0]height,
    input [7:0]width,
    output [7:0]addr_x0,
    output [7:0]addr_y0,
    output [7:0]gdata,
    output Gvector_sig
    );

wire [8:0]data;
wire [8:0]data_out;
wire [15:0]index;
wire swmv;

MedianFilter mfilter(
    .reset(reset),
    .enable(enable),
    .CLK(CLK),
    .Slow_clk(Slow_clk),
	 .Nxt_block_sig(Nxt_block_sig),
    .height(height),
    .width(width),
    .data(data),
	 .data_out(data_out),
    .index(index),
    .addr_x0,
    .addr_y0,
    .gdata(gdata),
    .Gvector_sig(Gvector_sig),
	 .swmv(swmv)
    );

Mvram_x ram (
  .clka(Slow_clk),
  .wea(swmv),
  .addra(index),
  .dina(data_out),
  .douta(data) 
);
endmodule
