`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:01:50 05/22/2014 
// Design Name: 
// Module Name:    pci 
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
module PCI(
    input [31:0] AD_I,
    output [31:0] AD_O,
    output [3:0] OE_AD_N,
    input [3:0] CBE_I,
    output [3:0] CBE_O,
    output OE_CBE_N,
    input PAR_I,
    output PAR_O,
    output OE_PAR_N,
    input FRAME_I,
    output FRAME_O,
    output OE_FRAME_N,
    input TRDY_I,
    output TRDY_O,
    output OE_TRDY_N,
    input IRDY_I,
    output IRDY_O,
    output OE_IRDY_N,
    input STOP_I,
    output STOP_O,
    output OE_STOP_N,
    input DEVSEL_I,
    output DEVSEL_O,
    output OE_DEVSEL_N,
	 input IDSEL_I,
    input PERR_I,
    output PERR_O,	 
    output OE_PERR_N,
    input SERR_I,
    output OE_SERR_N,
    output REQ_O,
    output OE_REQ_N,	 
    input GNT_I,
    input CLK,
    input RST_I,
    output RST_O,
    output OE_INTA_N,
    output PING_DONE,
    input PING_REQ,
	 output PCI_CE
    );
	 
assign OE_AD_N = 4'b1111;
assign OE_CBE_N = 1'b1;
assign OE_PAR_N = 1'b1;
assign OE_FRAME_N = 1'b1;
assign OE_TRDY_N = 1'b1;
assign OE_IRDY_N = 1'b1;
assign OE_STOP_N = 1'b1;
assign OE_DEVSEL_N = 1'b1;
assign OE_PERR_N = 1'b1;
assign OE_SERR_N = 1'b1;
assign OE_REQ_N = 1'b1;	 
assign OE_INTA_N = 1'b1;
	 
wire Block_IRDY;
wire Unconditional_Transfer;
wire Block_TRDY;
assign Block_IRDY = 1'b0;
assign Unconditional_Transfer = 1'b0;
assign Block_TRDY = 1'b0;

// assign	PCI_CE	= I2 | (!(I3 | TRDY)) | (!(I1 | IRDY));
PCILOGIC PCILOGIC (
				.IRDY(IRDY_I),
				.TRDY(TRDY_I),
				.I1(Block_IRDY),
				.I2(Unconditional_Transfer),
				.I3(Block_TRDY),
				.PCI_CE(PCI_CE)
				);



endmodule
