`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:53:54 05/22/2014 
// Design Name: 
// Module Name:    PCILOGIC 
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
module PCILOGIC (
				IRDY,
				TRDY,
				I1,
				I2,
				I3,
				PCI_CE
				);


input			IRDY;
input			TRDY;
input			I1;
input			I2;
input			I3;
output		PCI_CE;

//wire PCI_CE;
assign	PCI_CE	= I2 | (!(I3 | TRDY)) | (!(I1 | IRDY));

endmodule