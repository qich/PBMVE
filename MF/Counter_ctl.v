`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:03:30 07/19/2016 
// Design Name: 
// Module Name:    Counter_ctl 
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
module Counter_ctl(
    input Nxt_block_sig,
    input CLK,
	 input reset,
	 input enable,
    input [7:0]height,
    input [7:0]width,
    output [7:0]center_x,
    output [7:0]center_y,
    output Counter_fin
    );

//*************definition*************//
reg [1:0]state;
reg [1:0]next_state;
parameter idle = 2'd0;
parameter run = 2'd1;
parameter waiting = 2'd2;

reg Gvector_sig;
//************* Counter_ctl control *************//
always @(posedge CLK or posedge reset)
	begin
		if (reset)
			state <= idle;
		else
			state <= next_state;
	end
	
always @(*)
	begin
		case (state)
			idle :
				if ((enable == 1'b1) 
				&& (enable == 1'b1))
					next_state <= run;
				else	
					next_state <= idle;
			run :
				if ((enable == 1'b0) 
				|| (1'b0))//遍历结束
					next_state <= idle;
				else if(Gvector_sig == 1'b1)
					next_state <= waiting;
				else
					next_state <= run;
			waiting :
				if ((enable == 1'b0) 
				|| (1'b0))//遍历结束
					next_state <= idle;
				else if(Nxt_block_sig == 1'b1)
					next_state <= run;
				else
					next_state <= waiting;
		endcase
	end
//************* calculate *************//

always @(posedge clock or posedge reset)
	begin
		if (reset)
			begin
				center_x <= 8'd0;
				center_y <= 8'd0;
				Counter_fin <= 
			end
	end

endmodule
