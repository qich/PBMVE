`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:52:02 07/20/2016 
// Design Name: 
// Module Name:    Reconstructor 
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
module Reconstructor(
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
	 output MVF_complete_sig,
	 
	 input [1:0]data_type,
	 output [15:0]Tindex,
	 
	 input [5:0]pdi,
	 output [15:0]index,
	 output we,
	 output [8:0]datax_out,
	 output [8:0]datay_out,
	 output [5:0]pdo
    );
//***************************** definition ***************************//
reg [2:0] state;
reg [2:0] next_state;
reg block_sig;
assign Nxt_block_sig = block_sig;
parameter idle = 3'd0;
parameter waiting = 3'd1;
parameter bgen = 3'd2;
parameter ogen = 3'd3;
parameter comset = 3'd4;

reg Blo_fin;
reg OA_fin;
reg Com_fin;
reg Type_fin;
//***************************** CPU control *************************//
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
					block_sig <= 4'd0;
					if (enable)
						next_state <= waiting;
					else	
						next_state <= idle;
				end
			waiting :
				if (Vector_sig)
					begin
						next_state <= bgen;
						block_sig <= 4'd0;
					end
				else
					begin
						next_state <= waiting;
						block_sig <= 4'd1;
					end
			bgen :
				begin 
					block_sig <= 4'd0;
					if (Blo_fin)
						next_state <= ogen;
					else	
						next_state <= bgen;
				end
			ogen :
				begin 
					block_sig <= 4'd0;
					if (OA_fin)
						next_state <= comset;
					else	
						next_state <= ogen;
				end
			comset :
				begin 
					block_sig <= 4'd0;
					if (Com_fin)
						next_state <= waiting;
					else	if (Com_fin)
						next_state <= idle;
					else
						next_state <= comset;
				end
		endcase
	end

//***************************** Block_gen *************************//
reg [7:0]Raddr_x[0:3];
reg [7:0]Raddr_y[0:3];
wire [7:0]lookup;
assign lookup = Raddr_x[0];
reg c0;
always @(posedge CLK)
	begin
		if (state == idle)
			begin
				Blo_fin <= 0;
				c0 <= 1'b0;
			end
		else if (state == bgen)
			case (c0)
				1'b0 :
					begin
						c0 <= 1'b1;
						Blo_fin <= 1;
						Raddr_x[0] <= baddr1 (mv_x, addr_x); //左上
						Raddr_y[0] <= baddr1 (mv_y, addr_y);
						Raddr_x[1] <= baddr4 (mv_x, addr_x); //右上
						Raddr_y[1] <= baddr1 (mv_y, addr_y);
						Raddr_x[2] <= baddr1 (mv_x, addr_x); //左下
						Raddr_y[2] <= baddr4 (mv_x, addr_x); 
						Raddr_x[3] <= baddr4 (mv_x, addr_x); //右下
						Raddr_y[3] <= baddr4 (mv_x, addr_x);
					end
				1'b1 :
					begin
						Blo_fin <= 0;
						c0 <= 1'b0;
					end
			endcase
	end
/*********************************************************************/
function [7:0] baddr1;
  input [7:0] mv, addr;
  begin
    baddr1 = ((mv + (addr-1)*4 ) >> 2) + 1;
  end
endfunction

function [7:0] baddr2;
  input [7:0] mv, addr;
  begin
    baddr2 = ((mv + 1 + (addr-1)*4 ) >> 2) + 1;
  end
endfunction

function [7:0] baddr3;
  input [7:0] mv, addr;
  begin
    baddr3 = ((mv + 2 + (addr-1)*4 ) >> 2) + 1;
  end
endfunction

function [7:0] baddr4;
  input [7:0] mv, addr;
  begin
    baddr4 = ((mv + addr*4 - 1) >> 2)+ 1;
  end
endfunction

/**************************** OA_gen ********************************/
reg c1;
reg [4:0]OAvalue[0:3];
always @(posedge CLK)
	begin
		if (state == idle)
			begin
				c1 <= 0;
				OA_fin <= 1'b0;
			end
		else if (state == ogen)
			case (c1)
				1'b0 :
					begin
						OA_fin <= 1'b1;
						c1 <= 1'b1;
						OAvalue[0] = inBlock(baddr1(mv_x,addr_x),baddr1(mv_y,addr_y),Raddr_x[0],Raddr_y[0])
										+	inBlock(baddr1(mv_x,addr_x),baddr2(mv_y,addr_y),Raddr_x[0],Raddr_y[0])
										+	inBlock(baddr1(mv_x,addr_x),baddr3(mv_y,addr_y),Raddr_x[0],Raddr_y[0])
										+	inBlock(baddr1(mv_x,addr_x),baddr4(mv_y,addr_y),Raddr_x[0],Raddr_y[0])
										+	inBlock(baddr2(mv_x,addr_x),baddr1(mv_y,addr_y),Raddr_x[0],Raddr_y[0])
										+	inBlock(baddr2(mv_x,addr_x),baddr2(mv_y,addr_y),Raddr_x[0],Raddr_y[0])
										+	inBlock(baddr2(mv_x,addr_x),baddr3(mv_y,addr_y),Raddr_x[0],Raddr_y[0])
										+	inBlock(baddr2(mv_x,addr_x),baddr4(mv_y,addr_y),Raddr_x[0],Raddr_y[0])
										+	inBlock(baddr3(mv_x,addr_x),baddr1(mv_y,addr_y),Raddr_x[0],Raddr_y[0])
										+	inBlock(baddr3(mv_x,addr_x),baddr2(mv_y,addr_y),Raddr_x[0],Raddr_y[0])
										+	inBlock(baddr3(mv_x,addr_x),baddr3(mv_y,addr_y),Raddr_x[0],Raddr_y[0])
										+	inBlock(baddr3(mv_x,addr_x),baddr4(mv_y,addr_y),Raddr_x[0],Raddr_y[0])
										+	inBlock(baddr4(mv_x,addr_x),baddr1(mv_y,addr_y),Raddr_x[0],Raddr_y[0])
										+	inBlock(baddr4(mv_x,addr_x),baddr2(mv_y,addr_y),Raddr_x[0],Raddr_y[0])
										+	inBlock(baddr4(mv_x,addr_x),baddr3(mv_y,addr_y),Raddr_x[0],Raddr_y[0])
										+	inBlock(baddr4(mv_x,addr_x),baddr4(mv_y,addr_y),Raddr_x[0],Raddr_y[0]);
						OAvalue[1] = inBlock(baddr1(mv_x,addr_x),baddr1(mv_y,addr_y),Raddr_x[1],Raddr_y[1])
										+	inBlock(baddr1(mv_x,addr_x),baddr2(mv_y,addr_y),Raddr_x[1],Raddr_y[1])
										+	inBlock(baddr1(mv_x,addr_x),baddr3(mv_y,addr_y),Raddr_x[1],Raddr_y[1])
										+	inBlock(baddr1(mv_x,addr_x),baddr4(mv_y,addr_y),Raddr_x[1],Raddr_y[1])
										+	inBlock(baddr2(mv_x,addr_x),baddr1(mv_y,addr_y),Raddr_x[1],Raddr_y[1])
										+	inBlock(baddr2(mv_x,addr_x),baddr2(mv_y,addr_y),Raddr_x[1],Raddr_y[1])
										+	inBlock(baddr2(mv_x,addr_x),baddr3(mv_y,addr_y),Raddr_x[1],Raddr_y[1])
										+	inBlock(baddr2(mv_x,addr_x),baddr4(mv_y,addr_y),Raddr_x[1],Raddr_y[1])
										+	inBlock(baddr3(mv_x,addr_x),baddr1(mv_y,addr_y),Raddr_x[1],Raddr_y[1])
										+	inBlock(baddr3(mv_x,addr_x),baddr2(mv_y,addr_y),Raddr_x[1],Raddr_y[1])
										+	inBlock(baddr3(mv_x,addr_x),baddr3(mv_y,addr_y),Raddr_x[1],Raddr_y[1])
										+	inBlock(baddr3(mv_x,addr_x),baddr4(mv_y,addr_y),Raddr_x[1],Raddr_y[1])
										+	inBlock(baddr4(mv_x,addr_x),baddr1(mv_y,addr_y),Raddr_x[1],Raddr_y[1])
										+	inBlock(baddr4(mv_x,addr_x),baddr2(mv_y,addr_y),Raddr_x[1],Raddr_y[1])
										+	inBlock(baddr4(mv_x,addr_x),baddr3(mv_y,addr_y),Raddr_x[1],Raddr_y[1])
										+	inBlock(baddr4(mv_x,addr_x),baddr4(mv_y,addr_y),Raddr_x[1],Raddr_y[1]);
						OAvalue[2] = inBlock(baddr1(mv_x,addr_x),baddr1(mv_y,addr_y),Raddr_x[2],Raddr_y[2])
										+	inBlock(baddr1(mv_x,addr_x),baddr2(mv_y,addr_y),Raddr_x[2],Raddr_y[2])
										+	inBlock(baddr1(mv_x,addr_x),baddr3(mv_y,addr_y),Raddr_x[2],Raddr_y[2])
										+	inBlock(baddr1(mv_x,addr_x),baddr4(mv_y,addr_y),Raddr_x[2],Raddr_y[2])
										+	inBlock(baddr2(mv_x,addr_x),baddr1(mv_y,addr_y),Raddr_x[2],Raddr_y[2])
										+	inBlock(baddr2(mv_x,addr_x),baddr2(mv_y,addr_y),Raddr_x[2],Raddr_y[2])
										+	inBlock(baddr2(mv_x,addr_x),baddr3(mv_y,addr_y),Raddr_x[2],Raddr_y[2])
										+	inBlock(baddr2(mv_x,addr_x),baddr4(mv_y,addr_y),Raddr_x[2],Raddr_y[2])
										+	inBlock(baddr3(mv_x,addr_x),baddr1(mv_y,addr_y),Raddr_x[2],Raddr_y[2])
										+	inBlock(baddr3(mv_x,addr_x),baddr2(mv_y,addr_y),Raddr_x[2],Raddr_y[2])
										+	inBlock(baddr3(mv_x,addr_x),baddr3(mv_y,addr_y),Raddr_x[2],Raddr_y[2])
										+	inBlock(baddr3(mv_x,addr_x),baddr4(mv_y,addr_y),Raddr_x[2],Raddr_y[2])
										+	inBlock(baddr4(mv_x,addr_x),baddr1(mv_y,addr_y),Raddr_x[2],Raddr_y[2])
										+	inBlock(baddr4(mv_x,addr_x),baddr2(mv_y,addr_y),Raddr_x[2],Raddr_y[2])
										+	inBlock(baddr4(mv_x,addr_x),baddr3(mv_y,addr_y),Raddr_x[2],Raddr_y[2])
										+	inBlock(baddr4(mv_x,addr_x),baddr4(mv_y,addr_y),Raddr_x[2],Raddr_y[2]);
						OAvalue[3] = inBlock(baddr1(mv_x,addr_x),baddr1(mv_y,addr_y),Raddr_x[3],Raddr_y[3])
										+	inBlock(baddr1(mv_x,addr_x),baddr2(mv_y,addr_y),Raddr_x[3],Raddr_y[3])
										+	inBlock(baddr1(mv_x,addr_x),baddr3(mv_y,addr_y),Raddr_x[3],Raddr_y[3])
										+	inBlock(baddr1(mv_x,addr_x),baddr4(mv_y,addr_y),Raddr_x[3],Raddr_y[3])
										+	inBlock(baddr2(mv_x,addr_x),baddr1(mv_y,addr_y),Raddr_x[3],Raddr_y[3])
										+	inBlock(baddr2(mv_x,addr_x),baddr2(mv_y,addr_y),Raddr_x[3],Raddr_y[3])
										+	inBlock(baddr2(mv_x,addr_x),baddr3(mv_y,addr_y),Raddr_x[3],Raddr_y[3])
										+	inBlock(baddr2(mv_x,addr_x),baddr4(mv_y,addr_y),Raddr_x[3],Raddr_y[3])
										+	inBlock(baddr3(mv_x,addr_x),baddr1(mv_y,addr_y),Raddr_x[3],Raddr_y[3])
										+	inBlock(baddr3(mv_x,addr_x),baddr2(mv_y,addr_y),Raddr_x[3],Raddr_y[3])
										+	inBlock(baddr3(mv_x,addr_x),baddr3(mv_y,addr_y),Raddr_x[3],Raddr_y[3])
										+	inBlock(baddr3(mv_x,addr_x),baddr4(mv_y,addr_y),Raddr_x[3],Raddr_y[3])
										+	inBlock(baddr4(mv_x,addr_x),baddr1(mv_y,addr_y),Raddr_x[3],Raddr_y[3])
										+	inBlock(baddr4(mv_x,addr_x),baddr2(mv_y,addr_y),Raddr_x[3],Raddr_y[3])
										+	inBlock(baddr4(mv_x,addr_x),baddr3(mv_y,addr_y),Raddr_x[3],Raddr_y[3])
										+	inBlock(baddr4(mv_x,addr_x),baddr4(mv_y,addr_y),Raddr_x[3],Raddr_y[3]);
					end
				1'b1 :
					begin
						OA_fin <= 1'b0;
						c1 <= 1'b0;
					end
			endcase
	end
/*********************************************************************/
function  inBlock;
  input [7:0] addrx, addry, blockx, blocky;
  begin
    inBlock = (addrx == blockx) && (addry == blocky);
  end
endfunction

/**************************** Tinterface ********************************/
reg [1:0]ct;
reg [1:0]type;
assign Tindex = (addr_y-1)*width + addr_x-1;
always @(posedge CLK)
	type <= data_type;
/**************************** Comset ********************************/
reg [4:0]c2;
reg [5:0]p_out;
reg wlf;
reg [2:0]reg_index;
assign we = wlf;
assign index = Raddr_x[reg_index]-1 + (Raddr_y[reg_index]-1)*width ;
assign pdo = p_out;
assign datax_out = {1'b0,mv_x};
assign datay_out = {1'b0,mv_y};
always @(negedge Slow_clk)
	begin
		if (state != idle && state != comset)
			begin
				c2 <= 0;
				Com_fin <= 0;
				reg_index <= 0;
			end
		else if (state == comset)
			case (c2)
				4'd0	:
					begin
						c2 <= c2+1;
						wlf <= 0;//read P
						p_out <= OAvalue[reg_index] + type*4;
						reg_index <= 0;
					end
				4'd1	:
					begin
						if ( p_out > pdi ) begin wlf <= 1; c2 <= c2+1; end
						else c2 <= c2+2; 
					end
				4'd2	:
					begin
						c2 <= c2+1;
						wlf <= 0;
						reg_index <= 1;
					end
				
				4'd3	:
					begin
						c2 <= c2+1;
						wlf <= 0;//read P
						p_out <= OAvalue[reg_index] + type*4;
					end
				4'd4	:
					begin
						if ( p_out > pdi ) begin wlf <= 1; c2 <= c2+1; end
						else c2 <= c2+2; 
					end
				4'd5	:
					begin
						c2 <= c2+1;
						wlf <= 0;
						reg_index <= 2;
					end
				
				4'd6	:
					begin
						c2 <= c2+1;
						wlf <= 0;//read P
						p_out <= OAvalue[reg_index] + type*4;
					end
				4'd7	:
					begin
						if ( p_out > pdi ) begin wlf <= 1; c2 <= c2+1; end
						else c2 <= c2+2; 
					end
				4'd8	:
					begin
						c2 <= c2+1;
						wlf <= 0;
						reg_index <= 3;
					end
				
				4'd9	:
					begin
						c2 <= c2+1;
						wlf <= 0;//read P
						p_out <= OAvalue[reg_index] + type*4;
					end
				4'd10	:
					begin
						if ( p_out > pdi ) begin wlf <= 1; c2 <= c2+1; end
						else c2 <= c2+2; 
					end
				4'd11	:
					begin
						c2 <= c2+1;
						wlf <= 0;
						reg_index <= 0;
					end
				4'd12 :
					begin
						c2 <= c2+1;
						Com_fin <= 1;
					end
				4'd13 :
					begin
						c2 <= 0;
						Com_fin <= 0;
					end
			endcase
	end
endmodule
