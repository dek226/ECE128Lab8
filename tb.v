`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2024 01:52:01 PM
// Design Name: 
// Module Name: upcount_tb
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

/**
module upcount_tb;
    reg clk, reset;
    wire [11:0] count_val;
    
    upCounter DUT(clk, reset, count_val);
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        #5 reset = 1;
        #5 reset = 0;
        #4095 $stop;
    end
endmodule
*/

/**
module bcd_tb;
    reg clk, en_in;
    reg [11:0] bin = 0;
    wire [15:0] bcd;
    wire bcd_en;
    
    bcd_doubleDabble DUT(clk, en_in, bin, bcd, bcd_en);
    initial 
    begin 
    clk = 0; 
    forever 
        begin 
        #10 clk = ~clk; //10*2 for full wave 
        end 
    end 
 
initial 
    begin 
    forever 
        begin 
        bin     = 0; 
        en_in          = 1; 
        #40  
        en_in          = 0; 
        @(posedge bcd_en);
        //#620;
 
        bin    = 12'b111111111111;
        en_in          = 1; 
        #40 
        en_in          = 0; 
        @(posedge bcd_en);
        //#620; 
 
        bin    = 0; 
        en_in          = 1; 
        #40 
        en_in          = 0; 
        @(posedge bcd_en);
        //#620; 
 
        bin    = bin + 1; 
        en_in          = 1; 
        #40 
        en_in          = 0; 
        @(posedge bcd_en);
        //#620;  
 
        bin    = bin + 10; 
        en_in          = 1; 
        #40 
        en_in          = 0; 
        @(posedge bcd_en);
        //#620; 
 
        bin    = bin + 10; 
        en_in          = 1; 
        #40 
        en_in          = 0; 
        @(posedge bcd_en);
        //#620; 
        
        bin    = bin + 100; 
        en_in          = 1; 
        #40 
        en_in          = 0; 
        @(posedge bcd_en);
        //#1340;   
 
        bin    = bin + 1000; 
        en_in          = 1; 
        #40 
        en_in          = 0; 
        @(posedge bcd_en);
        //#1340;
 
        bin    = bin + 1000; 
        en_in          = 1; 
        #40 
        en_in          = 0; 
        @(posedge bcd_en);
        //#1340;
 
        bin    = bin + 1; 
        en_in          = 1; 
        #40 
        en_in          = 0; 
        @(posedge bcd_en);
        //#1340; 
 
        bin    = bin + 2; 
        en_in          = 1; 
        #40 
        en_in          = 0; 
        @(posedge bcd_en);
        //#1340; 
 
        bin    = bin + 2; 
        en_in          = 1; 
        #40 
        en_in          = 0; 
        @(posedge bcd_en);
        //#1340;  
 
        bin    = bin + 5; 
        en_in          = 1; 
        #40 
        en_in          = 0; 
        @(posedge bcd_en);
        //#1340; 
        end 
    end 
endmodule
*/

module bcd_tb2;
    reg clk;
    wire [6:0] seg_cathode;
	wire [3:0] seg_anode_o;
    
    top_multi_digit DUT(clk, seg_cathode, seg_anode_o);
    initial 
    begin 
    clk = 0; 
    forever 
        begin 
        #10 clk = ~clk; //10*2 for full wave 
        end 
    end 
    /**
    initial begin
        //en_in          = 1; 
        #40 
        en_in          = 0; 
    end
    */
 endmodule
