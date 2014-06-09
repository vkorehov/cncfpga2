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
    output reg [31:0] AD_O,
    output reg OE_AD_N,
    input [3:0] CBE_I_N,
    output [3:0] CBE_O_N,
    output OE_CBE_N,
    input PAR_I,
    output reg PAR_O,
    output reg OE_PAR_N,
    input FRAME_I_N,
    output FRAME_O_N,
    output OE_FRAME_N,
    input TRDY_I_N,
    output reg TRDY_O_N,
    output reg OE_TRDY_N,
    input IRDY_I_N,
    output IRDY_O_N,
    output OE_IRDY_N,
    input STOP_I_N,
    output reg STOP_O_N,
    output reg OE_STOP_N,
    input DEVSEL_I_N,
    output reg DEVSEL_O_N,
    output reg OE_DEVSEL_N,
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
    input RST
    );

parameter BAR1_WINDOW_BITS = 4;
parameter BAR2_WINDOW_BITS = 4;
parameter IO_BITS = (BAR1_WINDOW_BITS-2);
parameter MEM_BITS =(BAR2_WINDOW_BITS-2);

// Device ID and Vendor ID
parameter [15:0] CFG_DEVICE = 16'h0300;
// Device ID and Vendor ID
parameter [15:0] CFG_VENDOR = 16'h10ee;
// Class Code
parameter [15:0] CFG_CC = 16'h0b40;
// Revision ID
parameter [15:0] CFG_REVISION = 16'h0000;

reg [31:0] io[0:(IO_BITS-1)];
reg [31:0] mem[0:(MEM_BITS-1)];
reg [31:BAR1_WINDOW_BITS] Bar1Addr;// we respond to an "IO write" at this address
reg [31:BAR2_WINDOW_BITS] Bar2Addr;// we respond to an "MEM write" at this address

reg [1:0] Transaction;
parameter TX_IDLE = 2'b00;
parameter TX_DEVSEL = 2'b01;
parameter TX_TRDY = 2'b10;
parameter TX_STOP = 2'b11;

reg [5:0] CurrentAddr;
reg [31:0] CurrentOutput;

reg PCICommandIOSpaceBit0; // PCI Command register
reg PCICommandMEMSpaceBit1; // PCI Command register
reg PCICommandIntrDisableBit10; // PCI Command register
reg PCIIntrStatusBit3; // PCI Status

wire [15:0]PCIStatus = {
    /*Detected Parity Error*/1'b0,
    /*Signaled system Error*/1'b0,
    /*Received Master Abort*/1'b0,
    /*Received Target Abort*/1'b0,
    /*Signaled Target Abort*/1'b0,
    /*DEVSEL timing=MED*/2'b01,
    /*Master Data Parity Error*/1'b0,
    /*Fast Back-to-Back Capable*/1'b0,
    /*reserved*/1'b0,
    /*66MHZ*/1'b0,
    /*CapabilitiesList*/1'b0,
    PCIIntrStatusBit3,
    /*Reserved*/1'b0,
    /*Reserved*/1'b0,
    /*Reserved*/1'b0
};

wire [15:0]PCICommand = {
    /*Reserved*/ 1'b0,
    /*Reserved*/ 1'b0,
    /*Reserved*/ 1'b0,
    /*Reserved*/ 1'b0,
    /*Reserved*/ 1'b0,
    PCICommandIntrDisableBit10,
    /*Fast Back-to-Back Enable*/ 1'b0,
    /*SERR# Enable*/ 1'b0,
    /*Reserved*/ 1'b0,
    /*Parity Error Response*/ 1'b0,
    /*VGA Palette Snoop*/ 1'b0,
    /*Memory Write and Invalidate Enable*/ 1'b0,
    /*Special Cycles*/ 1'b0,
    /*Bus Master*/ 1'b0,
    PCICommandMEMSpaceBit1,
    PCICommandIOSpaceBit0
};


wire [8:0] PCIMaxLat = 8'b0;
wire [8:0] PCIMinGnt = 8'b0;
wire [8:0] PCIInterruptPin = 8'b00000001; // 1=#INTA, 0 = Disabled
reg [8:0] PCIInterruptLine;
reg LastParity;

assign OE_REQ_N = 1'b1;
assign CBE_O_N = 4'b0;
assign OE_CBE_N = 1'b1;     
assign OE_FRAME_N = 1'b1;
assign OE_IRDY_N = 1'b1;
assign OE_PERR_N = 1'b1;
assign OE_SERR_N = 1'b1;
assign OE_REQ_N = 1'b1;     
assign OE_INTA_N = 1'b1;


integer k;
initial
begin 
    Bar1Addr[31:BAR1_WINDOW_BITS] = 32'b0;
    Bar2Addr[31:BAR2_WINDOW_BITS] = 32'b0;
    Transaction = TX_IDLE;
    CurrentAddr = 32'b0;
    
    for (k = 0; k < IO_BITS; k = k + 1)
    begin
        io[k] = 32'b0;
    end
    for (k = 0; k < MEM_BITS; k = k + 1)
    begin
        mem[k] = 32'b0;
    end    

    PCICommandIOSpaceBit0 = 1'b0;
    PCICommandMEMSpaceBit1 = 1'b0;
    PCICommandIntrDisableBit10 = 1'b0;
    PCIIntrStatusBit3 = 1'b0;
    PCIInterruptLine = 8'b0;
                
    OE_AD_N = 1'b1;
    
    TRDY_O_N = 1'b1;
    OE_TRDY_N = 1'b1;

    STOP_O_N = 1'b1;
    OE_STOP_N = 1'b1;


    DEVSEL_O_N = 1'b1;     
    OE_DEVSEL_N = 1'b1;
    
    OE_PAR_N = 1'b1;
    
    PING_DONE = 1'b0;
end


reg IsWrite;
wire DataRead = (Transaction == TX_DEVSEL | Transaction == TX_TRDY) & ~IsWrite;
wire DataWrite = (Transaction == TX_TRDY) & ~IRDY_I_N & IsWrite;

wire BAR1Matches = (CBE_I_N[3:1] == 3'b001) & (AD_I[31:BAR1_WINDOW_BITS]==Bar1Addr[31:BAR1_WINDOW_BITS]) & (AD_I[1:0] == 2'b00);
wire BAR2Matches = (CBE_I_N[3:1] == 3'b011) & (AD_I[31:BAR2_WINDOW_BITS]==Bar2Addr[31:BAR2_WINDOW_BITS]);
wire CFGMatches = (CBE_I_N[3:1] == 3'b101) & (AD_I[1:0] == 2'b00) & (AD_I[10:8] == 3'b000);

reg [1:0] AccessType; // local
parameter ACCESS_IO = 2'b00;
parameter ACCESS_MEM = 2'b01;
parameter ACCESS_CONFIG = 2'b10;

always @(posedge CLK)
begin
   case(Transaction)   
       TX_STOP: begin
           Transaction <= TX_IDLE;
       end
       TX_DEVSEL: begin
           Transaction <= TX_TRDY;
       end
       TX_TRDY: begin
           if (FRAME_I_N)
               Transaction <= TX_STOP;
       end
       default: // TX_IDLE
       begin
           if (~FRAME_I_N & ((IDSEL_I & CFGMatches) | (PCICommandIOSpaceBit0 & BAR1Matches) | (PCICommandMEMSpaceBit1 & BAR2Matches)))
               Transaction <= TX_DEVSEL;
       end
   endcase
end

always @(posedge CLK)
begin
    CurrentAddr <= (Transaction == TX_IDLE) ? (IDSEL_I ? AD_I[7:2] :
                                                 (CBE_I_N[2] ? {32'b0, AD_I[BAR2_WINDOW_BITS-1:2]} :
                                                     {32'b0, AD_I[BAR1_WINDOW_BITS-1:2]})) :
                                                         CurrentAddr;
    
    IsWrite <= (Transaction == TX_IDLE) ? CBE_I_N[0] : IsWrite;
    AccessType <= (Transaction == TX_IDLE) ? {CBE_I_N[3], CBE_I_N[2]} : AccessType;

    DEVSEL_O_N <= ~(Transaction == TX_DEVSEL | Transaction == TX_TRDY);
    OE_DEVSEL_N <= ~(Transaction == TX_DEVSEL | Transaction == TX_TRDY | Transaction == TX_STOP);
    TRDY_O_N <= ~(Transaction == TX_TRDY);
    OE_TRDY_N <= ~(Transaction == TX_TRDY | Transaction == TX_STOP);
    STOP_O_N <= ~(Transaction == TX_TRDY);
    OE_STOP_N <= ~(Transaction == TX_TRDY | Transaction == TX_STOP);
    OE_AD_N <= ~((Transaction == TX_DEVSEL | Transaction == TX_TRDY) & ~IsWrite);
    OE_PAR_N <= ~((Transaction == TX_DEVSEL | Transaction == TX_TRDY | Transaction == TX_STOP) & ~IsWrite);
    
    // Output parity with 1 clock shift
    // Parity calculation
    PAR_O <= LastParity;
    AD_O <= CurrentOutput;
end



// Transfer handling
always @(posedge CLK)
begin
   if (DataRead) // Read transaction?
       case (AccessType)
           ACCESS_CONFIG: begin
               case(CurrentAddr)
                   0: CurrentOutput <= {CFG_DEVICE, CFG_VENDOR};
                   1: CurrentOutput <= {PCIStatus, PCICommand};
                   2: CurrentOutput <= {CFG_CC, CFG_REVISION};
                   4: CurrentOutput <= {Bar1Addr[31:BAR1_WINDOW_BITS], {(BAR1_WINDOW_BITS-1){1'b0}}, /* IO space */1'b1};
                   5: CurrentOutput <= {Bar2Addr[31:BAR2_WINDOW_BITS], {(BAR2_WINDOW_BITS-4){1'b0}}, /* MEM space, Prefetch=true,location=32bit */4'b1000};
                   15: CurrentOutput <= {PCIMaxLat, PCIMinGnt, PCIInterruptPin, PCIInterruptLine};
                   16: CurrentOutput <= {32'b0, Bar1Addr};
                   17: CurrentOutput <= {32'b0, Bar2Addr};
                   default: CurrentOutput <= 32'b0;
               endcase
           end
           ACCESS_MEM : begin
               CurrentOutput <= mem[CurrentAddr];
           end
           ACCESS_IO : begin
               CurrentOutput <= io[CurrentAddr];           
           end
       endcase
       
   LastParity <= ^{CurrentOutput, CBE_I_N};
end



always @(posedge CLK)
begin
    if (DataWrite) // Write transaction?
       case (AccessType)
           ACCESS_CONFIG: begin
               case(CurrentAddr)
                   1: begin
                       if (~CBE_I_N[1])
                           PCICommandIntrDisableBit10 = AD_I[10];
                       if (~CBE_I_N[0])
                       begin
                           PCICommandIOSpaceBit0 = AD_I[0];
                           PCICommandMEMSpaceBit1 = AD_I[1];
                       end
                   end
                   4: begin
                       Bar1Addr[31:BAR1_WINDOW_BITS] = AD_I[31:BAR1_WINDOW_BITS];
                   end
                   5: begin
                       Bar2Addr[31:BAR2_WINDOW_BITS] = AD_I[31:BAR2_WINDOW_BITS];
                   end
                   15: begin
                       if (~CBE_I_N[0])
                          PCIInterruptLine = AD_I[7:0];
                   end
                   default: begin end // do nothing
               endcase
           end
           ACCESS_MEM : begin
               mem[CurrentAddr] = AD_I;
           end
           ACCESS_IO : begin
               io[CurrentAddr] = AD_I;
           end
       endcase
end

endmodule

//assign    PCI_CE    = I2 | (!(I3 | TRDY)) | (!(I1 | IRDY));
//PCILOGIC PCILOGIC (
//                .IRDY(IRDY_IN),
//                .TRDY(TRDY_IN),
//                .I1(1'b0),
//                .I2(1'b0),
//                .I3(1'b1),
//                .PCI_CE(PCI_CE)
//                );


