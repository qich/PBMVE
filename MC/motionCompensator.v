`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:45:31 08/03/2016 
// Design Name: 
// Module Name:    motionCompensator 
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
module motionCompensator(
    input MV_fin,
    input CLK,
	 input reset,
    input [7:0]height,
    input [7:0]width,
    output reg LF_conceal,
	 
	 output [15:0]index,
	 input [7:0]mvx,
	 input [7:0]mvy,
	 output reg we,
	 output [15:0]indexRGB,
	 output [15:0]indexLF
    );

reg [1:0]state;
parameter idle = 0;
parameter run = 1;
parameter finish = 2;

always @(posedge CLK or posedge reset)
	begin
		if(reset)
			state <= idle;
		else begin
			case (state)
				idle :
					begin
						if(MV_fin)
							state <= run;
					end
				run :
					begin
						if(LF_conceal)
							state <= finish;
					end
				
			endcase
		end
	end

reg [7:0]addrx;
reg [7:0]addry;
reg signed [7:0]RGBx;
reg signed [7:0]RGBy;
reg [7:0]LFx;
reg [7:0]LFy;
reg [7:0]tmpx;
reg [7:0]tmpy;
reg [4:0]c;
reg endFlag;

assign index = addrx-1 + (addry-1)*width;
assign indexRGB = (RGBx>0 && RGBy>0)?(RGBx-1 + (RGBy-1)*width*4):0;
assign indexLF = tmpx-1 + (tmpy-1)*width*4;
always @(posedge CLK)
	begin	
		if(state == idle) begin 
			tmpx <= 1;
			tmpy <= 1;
		end
		else begin
			tmpx <= LFx;
			tmpy <= LFy;
		end
	end
always @(posedge CLK)
	begin
		if(state == idle)
			begin
				addrx <= 1;
				addry <= 1;
				RGBx <= 1;
				RGBy <= 1;
				LFx <= 1;
				LFy <= 1;
				LFx <= 1;
				LFx <= 1;
				we <= 0;
				c <= 0;
				LF_conceal <= 0;
				endFlag <= 0;
			end
		else if(state==run)
			begin
	/************************  controller  **************************/

				if(c == 0) begin
					RGBx <= addrx*4 - 3 - mvx; //harzard?
					RGBy <= addry*4 - 3 - mvy;
					LFx <= addrx*4 - 3;
					LFy <= addry*4 - 3;
					c <= c+1;
					we <= 1;
				end
				else if (c>0 && c<4) begin
					RGBx <= RGBx + 1;
					LFx <= LFx + 1;
					c <= c+1;
				end
				else if (c==4) begin
					RGBx <= addrx*4 - 3 - mvx;
					RGBy <= RGBy + 1;
					LFx <= addrx*4 - 3;
					LFy <= LFy + 1;
					c <= c+1;
				end
				else if (c>4 && c<8) begin
					RGBx <= RGBx + 1;
					LFx <= LFx + 1;
					c <= c+1;
				end
				else if (c==8) begin
					RGBx <= addrx*4 - 3 - mvx;
					RGBy <= RGBy + 1;
					LFx <= addrx*4 - 3;
					LFy <= LFy + 1;
					c <= c+1;
				end
				else if (c>8 && c<12) begin
					RGBx <= RGBx + 1;
					LFx <= LFx + 1;
					c <= c+1;
				end
				else if (c==12) begin
					RGBx <= addrx*4 - 3 - mvx;
					RGBy <= RGBy + 1;
					LFx <= addrx*4 - 3;
					LFy <= LFy + 1;
					c <= c+1;
				end
				else if (c>12 && c<15) begin
					RGBx <= RGBx + 1;
					LFx <= LFx + 1;
					c <= c+1;
					if (c==14) begin
						if(addry!=height || addrx!=width) begin
							addrx <= (addrx==width)?1:addrx+1;
							addry <= (addrx==width)?addry+1:addry;
						end
						else endFlag <= 1;
					end
				end
				else if (c==15) begin
					RGBx <= RGBx + 1;
					LFx <= LFx + 1;
					if(endFlag)begin c<=c+1; end
					else begin
						c<=0;
					end
				end
				else if (c==16) begin
					c <= c+1;
					LF_conceal <= 1; 
				end
				else if (c==17) begin
					we <= 0;
					c <= 0;
				end
			end
		end

endmodule
