`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:35:16 07/19/2016 
// Design Name: 
// Module Name:    MedianFilter 
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
module MedianFilter(
    input reset,
    input enable,
    input CLK,
    input Slow_clk,
	 input Nxt_block_sig,
    input [7:0]height,
    input [7:0]width,
    input [8:0]data,
	 output [8:0]data_out,
    output [15:0]index,
    output [7:0]addr_x0,
    output [7:0]addr_y0,
    output [7:0]gdata,
    output Gvector_sig,
	 output reg swmv
    );
//*************************** definition ******************************//
reg [2:0]state;
reg [2:0]next_state;
parameter idle = 3'd0;
parameter cout = 3'd1;
parameter gen = 3'd2;
parameter mfgen = 3'd3;
parameter waiting = 3'd4;

reg cout_fin; 
reg halt;

reg gen_fin; 
reg mfgen_start;
reg mfgen_fin;
//************output**************//
assign addr_x0 = center_x;
assign addr_y0 = center_y;
assign gdata = swmv  ? medfilt_data : idata;
assign Gvector_sig = tmp_sig;
//**************************** control *********************************//
reg tmp_sig;
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
				begin
					tmp_sig <= 1'b0;
					if (enable == 1'b1) 
						next_state <= cout;
					else	
						next_state <= idle;
				end
			cout :
				begin
					tmp_sig <= 1'b0;
					if (halt)
						next_state <= idle;
					else if (cout_fin)
						next_state <= gen;
					else
						next_state <= cout;
				end
			gen :
				if (gen_fin && mfgen_start)
					next_state <= mfgen;
				else if (gen_fin)
					next_state <= waiting;
				else 
					next_state <= gen;
			mfgen :
				if (mfgen_fin)
					next_state <= waiting;
				else
					next_state <= mfgen;
			waiting :
				begin
					tmp_sig <= 1'b1;
					if (Nxt_block_sig)
						next_state <= cout;
					else
						next_state <= waiting;
				end
		endcase
	end
//************************************* cout *******************************//
reg [7:0]center_x; //从1开始
reg [7:0]center_y;
reg [1:0]c0;
always @(posedge CLK)
	begin
		if (state == idle)
			begin
				cout_fin <= 1'b0;
				center_x <= 8'd0;
				center_y <= 8'd1;
				c0 <= 1'd0;
				halt <= 0;
			end
		else if(state == cout)//TODO，减少一个状态
			begin
				case (c0)
					2'd0 : 
						begin
							c0 <= 1'd1;
							if(center_x == width)
								begin
									center_x <= 8'd1;
									center_y <= center_y + 8'd1;
								end
							else
								center_x <= center_x + 8'd1;
							cout_fin <= 1'b1;
							if(center_y > height)
								halt <= 1;
						end
					2'd1 :
						begin
							c0 <= 2'd0;
							cout_fin <= 1'b0;
						end
				endcase
			end
	end
//************************************* Mv_interface ***************************//
reg [8:0]idata;
reg data_fin;
reg [1:0]dataState;
reg rise;
parameter s0 = 2'd0;
parameter s1 = 2'd1;
parameter s2 = 2'd2;

//assign swmv = Gvector_sig | wmv; //TODO
//assign swmv = 0;
assign index = swmv?(addr_y0-1)*width + addr_x0-1:(addr_row-1)*width + addr_col-1;//TODO
assign data_out = medfilt_data;
always @(posedge CLK or posedge reset)
	begin
		if (reset)
			begin
				idata <= 9'd0;
				data_fin <= 1'b0;
				dataState <= s0;
				swmv <= 1'b0;
			end
		else
			case (dataState)
				s0 :
					begin
						if ( state == gen && data_call )
							begin
								swmv <= 1'b0;
								if (addr_col < 8'b1 
								|| addr_col > width 
								|| addr_row < 8'b1 
								|| addr_row >height )//出界
									begin
										idata <= 9'd0;
										data_fin <= 1'b1;
										dataState <= s2;
									end
								else
									begin
										dataState <= s1;
									end
							end
						else if ( mfgen_fin )
							begin
								dataState <= s1;
								swmv <= 1'b1;
							end
						else
							dataState <= s0;
					end
				s1 :
					begin
						if( data_call ) 
							begin
								idata <= data;
								data_fin <= 1'b1;
							end
						dataState <= s2;
					end
				s2 :
					begin
						swmv <= 1'b0;
						data_fin <= 1'b0;
						dataState <= s0;
					end
			endcase
	end
//********************************** gen *************************************//
reg [4:0]c1;
reg [7:0]addr_col;
reg [7:0]addr_row;
reg data_call;
reg [3:0]nncounter;
reg [8:0]r_data[0:7];
parameter endstate = 5'd10;
always @(posedge CLK)
	begin
		if (state == idle)
			begin
				gen_fin <= 1'b0;
				mfgen_start <= 1'b0;
				c1 <= 5'd0;
				data_call <= 1'b0;
				nncounter <= 4'd0;
			end
		else if(state == gen)
			begin
				case (c1)
					5'd0 :
						begin
							c1 <= c1 + 5'd1;	
							gen_fin <= 1'b0;
							mfgen_start <= 1'b0;
							addr_col <= center_x;
							addr_row <= center_y;
							data_call <= 1'b1;
							nncounter <= 4'd0;;
						end
					5'd1 :
						if (data_fin)
							begin
								if (idata[8]==1'b1)//NULL
									begin
										c1 <= c1 + 5'd1;
										addr_col <= center_x - 8'd1;
										addr_row <= center_y - 8'd1;
										data_call <= 1'b1;
									end
								else
									begin
										gen_fin <= 1'b1;
										data_call <= 1'b0;
										c1 <= 5'd10;
									end
							end
					5'd2 :
						if (data_fin)
							begin
								c1 <= c1 + 5'd1;
								addr_col <= center_x;
								data_call <= 1'b1;
								if (idata[8]!=1'b1)//NULL
									begin
										r_data[nncounter] <= idata;
										nncounter <= nncounter + 4'd1;
									end
							end
					5'd3 :
						if (data_fin)
							begin
								c1 <= c1 + 5'd1;
								addr_col <= center_x + 8'd1;
								data_call <= 1'b1;
								if (idata[8]!=1'b1)//NULL
									begin
										r_data[nncounter] <= idata;
										nncounter <= nncounter + 4'd1;
									end
							end
					5'd4 :
						if (data_fin)
							begin
								c1 <= c1 + 5'd1;
								addr_col <= center_x - 8'd1;
								addr_row <= center_y;
								data_call <= 1'b1;
								if (idata[8]!=1'b1)//NULL
									begin
										r_data[nncounter] <= idata;
										nncounter <= nncounter + 4'd1;
									end
							end
					5'd5 :
						if (data_fin)
							begin
								c1 <= c1 + 5'd1;
								addr_col <= center_x + 8'd1;
								data_call <= 1'b1;
								if (idata[8]!=1'b1)//NULL
									begin
										r_data[nncounter] <= idata;
										nncounter <= nncounter + 4'd1;
									end
							end
					5'd6 :
						if (data_fin)
							begin
								c1 <= c1 + 5'd1;
								addr_col <= center_x - 8'd1;
								addr_row <= center_y + 8'd1;
								data_call <= 1'b1;
								if (idata[8]!=1'b1)//NULL
									begin
										r_data[nncounter] <= idata;
										nncounter <= nncounter + 4'd1;
									end
							end
					5'd7 :
						if (data_fin)
							begin
								c1 <= c1 + 5'd1;
								addr_col <= center_x;
								data_call <= 1'b1;
								if (idata[8]!=1'b1)//NULL
									begin
										r_data[nncounter] <= idata;
										nncounter <= nncounter + 4'd1;
									end
							end
					5'd8 :
						if (data_fin)
							begin
								c1 <= c1 + 5'd1;
								addr_col <= center_x + 8'd1;
								data_call <= 1'b1;
								if (idata[8]!=1'b1)//NULL
									begin
										r_data[nncounter] <= idata;
										nncounter <= nncounter + 4'd1;
									end
							end
					5'd9 :
						if (data_fin)
							begin
								gen_fin <= 1'b1; 
								mfgen_start <= 1'b1;
								c1 <= c1 + 5'd1;
								data_call <= 1'b0;
								if (idata[8]!=1'b1)//NULL
									begin
										r_data[nncounter] <= idata;
										nncounter <= nncounter + 4'd1;
									end
							end
					5'd10 :
						begin
							c1 <= 5'd0;
							gen_fin <= 1'b0;
							mfgen_start <= 1'b0;
						end
				endcase
			end
	end
//********************************** mfgen *************************************//

reg [8:0]tmp_data[0:8];
reg [3:0]c2;
reg [8:0]medfilt_data;
always @(posedge CLK)
	begin
		if (state == idle)
			begin
				c2 <= 4'd0;
			end
		else if(state == mfgen)
			case (c2)
				4'd0 :
					begin
						mfgen_fin <= 1'b0;
						c2 <= c2 + 4'd1;
						tmp_data[0] <= (nncounter>0)?r_data[0]:9'd0;
						tmp_data[1] <= (nncounter>1)?r_data[1]:9'b011111111;
						tmp_data[2] <= (nncounter>2)?r_data[2]:9'd0;
						tmp_data[3] <= (nncounter>3)?r_data[3]:9'b011111111;
						tmp_data[4] <= (nncounter>4)?r_data[4]:9'd0;
						tmp_data[5] <= (nncounter>5)?r_data[5]:9'b011111111;
						tmp_data[6] <= (nncounter>6)?r_data[6]:9'd0;
						tmp_data[7] <= (nncounter>7)?r_data[7]:9'b011111111;
						tmp_data[8] <= 9'd0;
					end
				4'd1 :
					begin
						c2 <= c2 + 4'd1;
						tmp_data[0] <= max(tmp_data[0], tmp_data[1], tmp_data[2]); 
						tmp_data[1] <= max(tmp_data[3], tmp_data[4], tmp_data[5]); 
						tmp_data[2] <= max(tmp_data[6], tmp_data[7], tmp_data[8]);
						tmp_data[3] <= med(tmp_data[0], tmp_data[1], tmp_data[2]); 
						tmp_data[4] <= med(tmp_data[3], tmp_data[4], tmp_data[5]);
						tmp_data[5] <= med(tmp_data[6], tmp_data[7], tmp_data[8]);
						tmp_data[6] <= min(tmp_data[0], tmp_data[1], tmp_data[2]); 
						tmp_data[7] <= min(tmp_data[3], tmp_data[4], tmp_data[5]);
						tmp_data[8] <= min(tmp_data[6], tmp_data[7], tmp_data[8]);
					end
				4'd2 :
					begin
						c2 <= c2 + 4'd1;
						tmp_data[0] <= min(tmp_data[0], tmp_data[1], tmp_data[2]); 
						tmp_data[1] <= med(tmp_data[3], tmp_data[4], tmp_data[5]); 
						tmp_data[2] <= max(tmp_data[6], tmp_data[7], tmp_data[8]);
					end
				4'd3 :
					begin
						c2 <= c2 + 4'd1;
						mfgen_fin <= 1'b1;
						medfilt_data <= med(tmp_data[0], tmp_data[1], tmp_data[2]); 
					end
				4'd4 :
					begin
						c2 <= 4'd0;
						mfgen_fin <= 1'b0;
					end
			endcase
	end
/************************************************************************************/ 

function [7:0] max;//if the data is signed number, please add the char signed behind key function; 
  input [7:0] a, b, c;
  begin
    max = (((a >= b) ? a : b) >= c ) ?  ((a >= b) ? a : b) : c;
  end
endfunction

function [7:0] med;
  input [7:0] a, b, c;
  begin
     med = a < b ? (b < c ? b : a < c ? c : a) : (b > c ? b : a > c ? c : a);
  end
endfunction

function [7:0] min;
  input [7:0] a, b, c;
  begin
     min= (((a <= b) ? a : b) <= c ) ?  ((a <= b) ? a : b) : c;
  end
endfunction
          
/************************************************************************************/ 

endmodule
