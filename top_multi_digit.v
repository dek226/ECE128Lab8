`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2024 01:44:21 PM
// Design Name: 
// Module Name: Upcounter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module top_multi_digit(clk, seg_cathode, seg_anode_o); //edit
	input wire clk;
	//input wire [15:0] BCD_in;
	output wire [6:0] seg_cathode;
	output wire [3:0] seg_anode_o;
	wire [3:0] mux_out, decoder_out;
	wire reset = 0;
	wire en_o = 1;
	wire [11:0] count_val;
	wire [15:0] BCD_in;
	//wire [1:0] o_q
	assign seg_anode_o = ~decoder_out; 
	reg [15:0] bcd_reg;
	wire bcd_en;
	
	// Instantiate Modules
    upCounter UUT11 (.clk(clk), .reset(reset), .count_val(count_val), .bcd_en(bcd_en));
    bcd_doubleDabble UUT22 (.clk(clk), .en_in(en_o), .bin(count_val), .bcd(BCD_in), .bcd_en(bcd_en));
    anode_gen UUT1 (.clk(clk), .seg_anode(decoder_out));
    Mux_4to1_case UUT2 (.s(decoder_out), .i0(bcd_reg[15:12]), .i1(bcd_reg[11:8]), .i2(bcd_reg[7:4]), .i3(bcd_reg[3:0]), .o(mux_out));
    BCD_7_seg_conv UUT3 (.num(mux_out), .seg(seg_cathode));

    // Update BCD register on bcd_en
    always @(posedge clk) begin
        if (bcd_en)
            bcd_reg <= BCD_in;
    end
endmodule


module anode_gen(clk, seg_anode);
	input wire clk;
	output wire [3:0] seg_anode;
	wire [1:0] countToDecoder;
	
	
	refresh_counter UUT1(.clk(clk), .o_q(countToDecoder));
	shift_register UUT2(.count(countToDecoder), .mux(seg_anode));
	
endmodule


module refresh_counter(clk, o_q); //edit, might work 100%
	input wire clk;
	output reg [1:0] o_q = 0;
	reg [1:0] o_d = 0;
	reg [8:0] count = 9'b000000000;
	
	always@(posedge clk)
	begin
	    count = count + 9'b000000001;
		if(o_d == 2'b11 && count==9'b100000001) //&& count==32
		begin
			o_d = 2'b00;
			o_q <= o_d;
	    end
		else
		begin
			if(count == 9'b100000001)
			begin
			o_d = o_d + 1'b1;
			o_q <= o_d;
			end
		end
		if(count == 9'b100000001)
		//begin
		  count = 9'b000000000;
		//end
	end
endmodule


module shift_register(count, mux); //edit might not work 100%
	input wire [1:0] count;
	output reg [3:0] mux;
    
	always@ (*)
	begin
		case (count)
		  2'b00 : mux = 4'b1000;
		  2'b01 : mux = 4'b0100;
		  2'b10 : mux = 4'b0010;
		  2'b11 : mux = 4'b0001;
		  default : mux = 4'bxxxx;
		endcase
	end
endmodule


module Mux_4to1_case(s, i0, i1, i2, i3, o);
	input wire [3:0] s, i0, i1, i2, i3;
	output reg [3:0] o;
	
	always@(*) //means all inputs - s or i0 or i1 or i2 or i3
	begin
		case (s)
			4'b1000 : o = i0;
			4'b0100 : o = i1;
			4'b0010 : o = i2;
			4'b0001 : o = i3;
			default : o = 1'bx; //default is undefined
		endcase
	end
endmodule


module BCD_7_seg_conv(num, seg);
	input wire [3:0] num;
	//output dp;
	output reg [6:0] seg;
	//output [7:0] anode:
	
	//assign anode = {{7{1'b1}},~valid};
	//assign dp = 1'b1; //decimal point
	always@(num) //means all inputs - s or i0 or i1 or i2 or i3
	begin
		case (num) //case statement
			0 : seg = 7'b1000000; //0000001
			1 : seg = 7'b1111001; //1001111
			2 : seg = 7'b0100100; //0010010
			3 : seg = 7'b0110000; //0000110
			4 : seg = 7'b0011001; //1001100
			5 : seg = 7'b0010010; //0100100
			6 : seg = 7'b0000010; //0100000
			7 : seg = 7'b1111000; //0001111
			8 : seg = 7'b0000000; //0000000
			9 : seg = 7'b0010000; //0000100
			//switch off 7 segment character when the bcd digit is not a decimal number.
			default : seg = 7'b1111111; 
		endcase
    end
endmodule




module upCounter(clk, reset, count_val, bcd_en);
    input clk, reset, bcd_en;
    output reg[11:0] count_val;
    //output reg en_o;
     reg [16:0] cycle;  

    initial begin
        count_val = 12'd0;
        cycle = 17'd0;
    end
    
    always@(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            count_val <= 12'b000000000000;
            cycle <= 17'd00000000000000000;
        end
        else if (bcd_en)
        begin
            if (cycle == 17'd400) begin
                    count_val <= count_val + 1; 
                    cycle <= 17'd0;
                end else begin
                    cycle <= cycle + 1; 
                end
            end
        end
endmodule

module bcd_doubleDabble(clk, en_in, bin, bcd, bcd_en);
    input clk, en_in;
    input [11:0] bin;
    output [15:0] bcd;
    output bcd_en;
    
    //State variables
    parameter IDLE = 3'b000;
    parameter SETUP = 3'b001;
    parameter ADD = 3'b010;
    parameter SHIFT = 3'b011;
    parameter DONE = 3'b100;
    
    reg [27:0] shift_reg = 28'b0000000000000000000000000000;
    reg [2:0] state = 3'b000;
    reg busy = 0;
    reg [3:0] sh_counter = 4'b0000;
    reg [1:0] add_counter = 2'b00;
    reg result_rdy = 0;
    
    always@(posedge clk)
    begin
        if(en_in && ~busy)
        begin
            shift_reg <= {16'b0000000000000000, bin};
            state <= SETUP;
        end
        case(state)
            IDLE:
            begin
                result_rdy <= 0;
                busy <= 0;
            
            end
            SETUP:
            begin
                busy <= 1;
                state <= ADD;
                
            end
            ADD:
            begin
                case(add_counter)
                    0:
                    begin
                        if(shift_reg[15:12] >= 4'b0101)
                           shift_reg[27:12] <= shift_reg[27:12] + 4'b0011;
                        add_counter <= add_counter + 2'b01;
                    end
                    1:
                    begin
                        if(shift_reg[19:16] >= 4'b0101)
                            shift_reg[27:16] <= shift_reg[27:16] + 4'b0011;
                        add_counter <= add_counter + 2'b01;
                    end
                    2:
                    begin
                        if(shift_reg[23:20] >= 4'b0101)
                            shift_reg[27:20] <= shift_reg[27:20] + 4'b0011;
                        add_counter <= add_counter + 2'b01;
                    end
                    3:
                    begin
                        if(shift_reg[27:24] >= 4'b0101)
                            shift_reg[27:24] <= shift_reg[27:24] + 4'b0011;
                        add_counter <= 0;
                        state <= SHIFT;
                    end
                endcase
            end
            SHIFT:
            begin
                sh_counter <= sh_counter + 4'b0001;
                shift_reg <= shift_reg << 1;
                if(sh_counter == 4'b1011)
                begin
                    sh_counter <= 4'b0000;
                    state <= DONE;
                end
                else
                    state <= ADD;
            end
            DONE:
            begin
                result_rdy <= 1'b1;
                state <= IDLE;
                busy <= 0;
            end
            default:
            begin
                state <= IDLE;
            end
            
        endcase
    end
    assign bcd = shift_reg[27:12];
    assign bcd_en = result_rdy;
endmodule







