`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:14:16 08/03/2016 
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
    input CLK,
    input [7:0]height,
    input [7:0]width,
	 input reset,
    input MV_fin,
    output LF_conceal
    );
	 
wire [15:0]index;
wire [15:0]indexRGB;
wire [15:0]indexLF;
wire [7:0]mvx;
wire [7:0]mvy;
motionCompensator mc(
.MV_fin(MV_fin),
.CLK(CLK),
.reset(reset),
.height(height),
.width(width),
.LF_conceal(LF_conceal),

.index(index),
.mvx(mvx),
.mvy(mvy),
.we(we),
.indexRGB(indexRGB),
.indexLF(indexLF)
);

mvrom mv (
  .clka(CLK), // input clka
  .addra(index), // input [1 : 0] addra
  .douta(mvx) // output [8 : 0] douta
);
mvrom mv2 (
  .clka(CLK), // input clka
  .addra(index), // input [1 : 0] addra
  .douta(mvy) // output [8 : 0] douta
);
wire [7:0]data;
wire [7:0]douta;
ifram ifram (
  .clka(CLK), // input clka
  .wea(we), // input [0 : 0] wea
  .addra(indexLF), // input [5 : 0] addra
  .dina(data), // input [7 : 0] dina
  .douta(douta) // output [7 : 0] douta
);

Rrom R(
  .clka(CLK), // input clka
  .addra(indexRGB), // input [3 : 0] addra
  .douta(data) // output [7 : 0] douta
);

endmodule
