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
    output OE_AD_N,
    input [3:0] CBE_I_N,
    output [3:0] CBE_O_N,
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
     
parameter COMMAND_WRITE_BIT_0 = 1'b1;
parameter WINDOW_BITS = 3;
reg [31:0] mem;
     
reg [31:0] IO_ADDR;   // we respond to an "IO write" at this address
reg [WINDOW_BITS:0]Offset; // current data offset
reg IsWrite;


reg [31:0]AD_O_FF;
FDPE XPCI_ADOQ0 (.Q(AD_O[0]),.D(AD_O_FF[0]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ1 (.Q(AD_O[1]),.D(AD_O_FF[1]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ2 (.Q(AD_O[2]),.D(AD_O_FF[2]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ3 (.Q(AD_O[3]),.D(AD_O_FF[3]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ4 (.Q(AD_O[4]),.D(AD_O_FF[4]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ5 (.Q(AD_O[5]),.D(AD_O_FF[5]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ6 (.Q(AD_O[6]),.D(AD_O_FF[6]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ7 (.Q(AD_O[7]),.D(AD_O_FF[7]),.C(CLK),.CE(1'b1),.PRE(RST));

FDPE XPCI_ADOQ8 (.Q(AD_O[8]),.D(AD_O_FF[8]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ9 (.Q(AD_O[9]),.D(AD_O_FF[9]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ10 (.Q(AD_O[10]),.D(AD_O_FF[10]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ11 (.Q(AD_O[11]),.D(AD_O_FF[11]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ12 (.Q(AD_O[12]),.D(AD_O_FF[12]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ13 (.Q(AD_O[13]),.D(AD_O_FF[13]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ14 (.Q(AD_O[14]),.D(AD_O_FF[14]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ15 (.Q(AD_O[15]),.D(AD_O_FF[15]),.C(CLK),.CE(1'b1),.PRE(RST));

FDPE XPCI_ADOQ16 (.Q(AD_O[16]),.D(AD_O_FF[16]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ17 (.Q(AD_O[17]),.D(AD_O_FF[17]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ18 (.Q(AD_O[18]),.D(AD_O_FF[18]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ19 (.Q(AD_O[19]),.D(AD_O_FF[19]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ20 (.Q(AD_O[20]),.D(AD_O_FF[20]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ21 (.Q(AD_O[21]),.D(AD_O_FF[21]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ22 (.Q(AD_O[22]),.D(AD_O_FF[22]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ23 (.Q(AD_O[23]),.D(AD_O_FF[23]),.C(CLK),.CE(1'b1),.PRE(RST));

FDPE XPCI_ADOQ24 (.Q(AD_O[24]),.D(AD_O_FF[24]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ25 (.Q(AD_O[25]),.D(AD_O_FF[25]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ26 (.Q(AD_O[26]),.D(AD_O_FF[26]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ27 (.Q(AD_O[27]),.D(AD_O_FF[27]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ28 (.Q(AD_O[28]),.D(AD_O_FF[28]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ29 (.Q(AD_O[29]),.D(AD_O_FF[29]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ30 (.Q(AD_O[30]),.D(AD_O_FF[30]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADOQ31 (.Q(AD_O[31]),.D(AD_O_FF[31]),.C(CLK),.CE(1'b1),.PRE(RST));

reg OE_AD_FF_N;
FDPE XPCI_OEADOQ (.Q(OE_AD_N),.D(OE_AD_FF_N),.C(CLK),.CE(1'b1),.PRE(RST));


reg PAR_O_FF;
FDPE XPCI_PAROQ (.Q(PAR_O),.D(PAR_O_FF),.C(CLK),.CE(1'b1),.PRE(RST));
reg OE_PAR_FF_N;
FDPE XPCI_OEPAROQ (.Q(OE_PAR_N),.D(OE_PAR_FF_N),.C(CLK),.CE(1'b1),.PRE(RST));

reg [3:0] CBE_O_FF_N;
FDPE XPCI_CBEOQ0 (.Q(CBE_O_N[0]),.D(CBE_O_FF_N[0]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_CBEOQ1 (.Q(CBE_O_N[1]),.D(CBE_O_FF_N[1]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_CBEOQ2 (.Q(CBE_O_N[2]),.D(CBE_O_FF_N[2]),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_CBEOQ3 (.Q(CBE_O_N[3]),.D(CBE_O_FF_N[3]),.C(CLK),.CE(1'b1),.PRE(RST));

reg OE_CBE_FF_N;
FDPE XPCI_CBEOQ (.Q(OE_CBE_N),.D(OE_CBE_FF_N),.C(CLK),.CE(1'b1),.PRE(RST));

    
reg TRDY_O_FF_N;
FDPE XPCI_TRDYOQ (.Q(TRDY_O_N),.D(TRDY_O_FF_N),.C(CLK),.CE(1'b1),.PRE(RST));
reg OE_TRDY_FF_N;
FDPE XPCI_OETRDYOQ (.Q(OE_TRDY_N),.D(OE_TRDY_FF_N),.C(CLK),.CE(1'b1),.PRE(RST));

reg DEVSEL_O_FF_N;
FDPE XPCI_DEVSELOQ (.Q(DEVSEL_O_N),.D(DEVSEL_O_FF_N),.C(CLK),.CE(1'b1),.PRE(RST));

reg OE_DEVSEL_FF_N;
FDPE XPCI_OEDEVSELOQ (.Q(OE_DEVSEL_N),.D(OE_DEVSEL_FF_N),.C(CLK),.CE(1'b1),.PRE(RST));

//assign    PCI_CE    = I2 | (!(I3 | TRDY)) | (!(I1 | IRDY));
PCILOGIC PCILOGIC (
                .IRDY(IRDY_IN),
                .TRDY(TRDY_IN),
                .I1(1'b0),
                .I2(1'b0),
                .I3(1'b1),
                .PCI_CE(PCI_CE)
                );



     
assign OE_FRAME_N = 1'b1;
assign OE_IRDY_N = 1'b1;
assign OE_STOP_N = 1'b1;
assign OE_PERR_N = 1'b1;
assign OE_SERR_N = 1'b1;
assign OE_REQ_N = 1'b1;     
assign OE_INTA_N = 1'b1;

initial
begin 
    mem <= 0;
    IO_ADDR <= 32'h00000200;
    Offset <= 0;
    IsWrite <= 0;
    
    AD_O_FF <= 32'h00000000;   
    OE_AD_FF_N <= 1;
    
    TRDY_O_FF_N <= 1'b1;
    OE_TRDY_FF_N <= 1'b1;

    DEVSEL_O_FF_N <= 1;     
    OE_DEVSEL_FF_N <= 1'b1;
    
    PAR_O_FF <= 0;
    OE_PAR_FF_N <= 1'b1;
    
    CBE_O_FF_N <= 4'b1;
    OE_CBE_FF_N <= 1'b1;

    
    PING_DONE  <= 0;
end


wire TransactionStart = DEVSEL_O_FF_N & ~FRAME_I_N & (IDSEL_I | (AD_I[31:WINDOW_BITS]==IO_ADDR[31:WINDOW_BITS])); 
wire TransactionEnd = ~DEVSEL_O_FF_N & FRAME_I_N & IRDY_I_N;
wire DataTransfer = ~DEVSEL_O_FF_N & ~IRDY_I_N;

always @(posedge CLK)
begin
   if (TransactionStart)
   begin
       DEVSEL_O_FF_N <= 0;
       OE_DEVSEL_FF_N <= 0;
       IsWrite <= CBE_I_N[0];
       OE_TRDY_FF_N <= 0;
       TRDY_O_FF_N <= 0;           
       if (~CBE_I_N[0]) // Read transaction?
       begin
           AD_O_FF <= mem;
           OE_AD_FF_N <= 0;
           CBE_O_FF_N <= 4'b0;
           OE_CBE_FF_N <= 0;                  
       end
   end
   else if (DataTransfer)
   begin
       if (~IsWrite)
       begin
           // calculate parity
           PAR_O_FF <= ^{mem, CBE_O_FF_N};
           OE_PAR_FF_N <= 0;           
       end
       if (FRAME_I_N) // Last Data Transfer?
       begin
           // Signal High for now
           DEVSEL_O_FF_N <= 1;           
           TRDY_O_FF_N <= 1;
           // Turn off immediately
           OE_AD_FF_N <= 1;
           OE_PAR_FF_N <= 1;
           OE_CBE_FF_N <= 1;
       end
   end
   else if (~OE_DEVSEL_FF_N)
   begin                  
       // Turn off after 1 clock
       OE_DEVSEL_FF_N <= 1'b1;
       OE_TRDY_FF_N <= 1'b1;                  
       // Turn off again for extra resilience
       OE_AD_FF_N <= 1;
       OE_PAR_FF_N <= 1;
       OE_CBE_FF_N <= 1;      
       // Signal again for extra resilience
       DEVSEL_O_FF_N <= 1;           
       TRDY_O_FF_N <= 1;       
   end
end

always @(posedge CLK)
begin
    if (DataTransfer & IsWrite)
    begin
        PING_DONE <= AD_I[0];
        mem <= AD_I;
    end
end

endmodule


