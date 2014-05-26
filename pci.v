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
    input FRAME_I_N,
    output FRAME_O_N,
    output OE_FRAME_N,
    input TRDY_I_N,
    output TRDY_O_N,
    output OE_TRDY_N,
    input IRDY_I_N,
    output IRDY_O_N,
    output OE_IRDY_N,
    input STOP_I_N,
    output STOP_O_N,
    output OE_STOP_N,
    input DEVSEL_I_N,
    output DEVSEL_O_N,
    output OE_DEVSEL_N,
	 input IDSEL_I,
    input PERR_I_N,
    output PERR_O_N,	 
    output OE_PERR_N,
    input SERR_I_N,
    output OE_SERR_N,
    output OE_REQ_N,	 
    input GNT_I_N,
    input CLK,
    output OE_INTA_N,
    output reg PING_DONE,
	 input RST,
	 input IRDY_IN,
	 input TRDY_IN	 
    );
	 
reg TRDY_O_FF_N;
FDPE XPCI_TRDYOQ (.Q(TRDY_O_N),.D(TRDY_O_FF_N),.C(CLK),.CE(1'b1),.PRE(RST));
reg DEVSEL_O_FF_N;
FDPE XPCI_DEVSELOQ (.Q(DEVSEL_O_N),.D(DEVSEL_O_FF_N),.C(CLK),.CE(1'b1),.PRE(RST));

reg OE_DEVSEL_FF_N;
FDPE XPCI_OEDEVSELOQ (.Q(OE_DEVSEL_N),.D(OE_DEVSEL_FF_N),.C(CLK),.CE(1'b1),.PRE(RST));
reg OE_TRDY_FF_N;
FDPE XPCI_OETRDYOQ (.Q(OE_TRDY_N),.D(OE_TRDY_FF_N),.C(CLK),.CE(1'b1),.PRE(RST));

//assign	PCI_CE	= I2 | (!(I3 | TRDY)) | (!(I1 | IRDY));
PCILOGIC PCILOGIC (
				.IRDY(IRDY_IN),
				.TRDY(TRDY_IN),
				.I1(1'b0),
				.I2(1'b0),
				.I3(1'b1),
				.PCI_CE(PCI_CE)
				);



parameter CBECD_IOWrite = 4'b0011;
	 
reg [31:0] IO_ADDR;   // we respond to an "IO write" at this address
reg Transaction;
	 
assign OE_AD_N = 4'b1111;
assign OE_CBE_N = 1'b1;
assign OE_PAR_N = 1'b1;
assign OE_FRAME_N = 1'b1;
assign OE_IRDY_N = 1'b1;
assign OE_STOP_N = 1'b1;
assign OE_PERR_N = 1'b1;
assign OE_SERR_N = 1'b1;
assign OE_REQ_N = 1'b1;	 
assign OE_INTA_N = 1'b1;

initial
begin
    IO_ADDR <= 32'h00000200;
	 Transaction <= 0;

	 TRDY_O_FF_N <= 1'b1;
    OE_TRDY_FF_N <= 1'b1;
	 
	 DEVSEL_O_FF_N <= 1'b1;
    OE_DEVSEL_FF_N <= 1'b1;
	 
	 PING_DONE  <= 0;
end


////////////////////////////////////////////////////
wire TransactionStart = ~Transaction & ~FRAME_I_N;
wire TransactionEnd = Transaction & FRAME_I_N & IRDY_I_N;
wire Targeted = TransactionStart & (AD_I==IO_ADDR) & (CBE_I==CBECD_IOWrite);
wire LastDataTransfer = FRAME_I_N & ~IRDY_I_N & ~TRDY_O_FF_N;

always @(posedge CLK)
case(Transaction)
  1'b0: Transaction <= TransactionStart;
  1'b1: Transaction <= ~TransactionEnd;
endcase

always @(posedge CLK)
case(Transaction)
  1'b0: OE_DEVSEL_FF_N <= !Targeted;
  1'b1: if(TransactionEnd) OE_DEVSEL_FF_N <= 1'b1;
endcase

always @(posedge CLK)
case(Transaction)
  1'b0: DEVSEL_O_FF_N <= !Targeted;
  1'b1: DEVSEL_O_FF_N <= DEVSEL_O_FF_N | LastDataTransfer;
endcase

always @(posedge CLK)
case(Transaction)
  1'b0: OE_TRDY_FF_N <= !Targeted;
  1'b1: if(TransactionEnd) OE_TRDY_FF_N <= 1'b1;
endcase

always @(posedge CLK)
case(Transaction)
  1'b0: TRDY_O_FF_N <= !Targeted;
  1'b1: TRDY_O_FF_N <= TRDY_O_FF_N | LastDataTransfer;
endcase


wire DataTransfer = !DEVSEL_O_FF_N & ~IRDY_I_N & ~TRDY_O_FF_N;
always @(posedge CLK)
case(DataTransfer)
  1'b1: PING_DONE <= AD_I[0];
endcase

endmodule

