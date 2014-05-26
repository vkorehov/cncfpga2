`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:12:59 05/22/2014 
// Design Name: 
// Module Name:    cnc_top 
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
module cnc_top(
    inout [31:0] AD,
    inout [3:0] CBE_N,
	 inout PAR,
    inout FRAME_N,
    inout TRDY_N,
    inout IRDY_N,
    inout STOP_N,
    inout DEVSEL_N,
    input IDSEL,
    output INTA_N,
    inout PERR_N,
    inout SERR_N,
    output REQ_N,
    input GNT_N,
    input RST_N,
    input PCLK,
    output PING_DONE
    );
wire RST;

// clock
IBUFG_PCI33_5 XPCI_CKI      (.O(NUB),.I(PCLK));
BUFG XPCI_CKA               (.O(CLK),.I(NUB));

IBUF_PCI33_5  XPCI_RST      (.O(RST_I),.I(RST_N));
assign RST = ~RST_I;
// make sure that RST is bound to Global Reset Request, which will put all state to <initial> block defined one.
STARTUP_SPARTAN2 SPARTAN2(.GSR(RST));


IOBUF_PCI33_5 XPCI_ADB31 (.O(AD_IN31),.IO(AD[31]),.I(AD_O31),.T(OE_AD3_N));
IOBUF_PCI33_5 XPCI_ADB30 (.O(AD_IN30),.IO(AD[30]),.I(AD_O30),.T(OE_AD3_N));
IOBUF_PCI33_5 XPCI_ADB29 (.O(AD_IN29),.IO(AD[29]),.I(AD_O29),.T(OE_AD3_N));
IOBUF_PCI33_5 XPCI_ADB28 (.O(AD_IN28),.IO(AD[28]),.I(AD_O28),.T(OE_AD3_N));
IOBUF_PCI33_5 XPCI_ADB27 (.O(AD_IN27),.IO(AD[27]),.I(AD_O27),.T(OE_AD3_N));
IOBUF_PCI33_5 XPCI_ADB26 (.O(AD_IN26),.IO(AD[26]),.I(AD_O26),.T(OE_AD3_N));
IOBUF_PCI33_5 XPCI_ADB25 (.O(AD_IN25),.IO(AD[25]),.I(AD_O25),.T(OE_AD3_N));
IOBUF_PCI33_5 XPCI_ADB24 (.O(AD_IN24),.IO(AD[24]),.I(AD_O24),.T(OE_AD3_N));

IOBUF_PCI33_5 XPCI_ADB23 (.O(AD_IN23),.IO(AD[23]),.I(AD_O23),.T(OE_AD2_N));
IOBUF_PCI33_5 XPCI_ADB22 (.O(AD_IN22),.IO(AD[22]),.I(AD_O22),.T(OE_AD2_N));
IOBUF_PCI33_5 XPCI_ADB21 (.O(AD_IN21),.IO(AD[21]),.I(AD_O21),.T(OE_AD2_N));
IOBUF_PCI33_5 XPCI_ADB20 (.O(AD_IN20),.IO(AD[20]),.I(AD_O20),.T(OE_AD2_N));
IOBUF_PCI33_5 XPCI_ADB19 (.O(AD_IN19),.IO(AD[19]),.I(AD_O19),.T(OE_AD2_N));
IOBUF_PCI33_5 XPCI_ADB18 (.O(AD_IN18),.IO(AD[18]),.I(AD_O18),.T(OE_AD2_N));
IOBUF_PCI33_5 XPCI_ADB17 (.O(AD_IN17),.IO(AD[17]),.I(AD_O17),.T(OE_AD2_N));
IOBUF_PCI33_5 XPCI_ADB16 (.O(AD_IN16),.IO(AD[16]),.I(AD_O16),.T(OE_AD2_N));

IOBUF_PCI33_5 XPCI_ADB15 (.O(AD_IN15),.IO(AD[15]),.I(AD_O15),.T(OE_AD1_N));
IOBUF_PCI33_5 XPCI_ADB14 (.O(AD_IN14),.IO(AD[14]),.I(AD_O14),.T(OE_AD1_N));
IOBUF_PCI33_5 XPCI_ADB13 (.O(AD_IN13),.IO(AD[13]),.I(AD_O13),.T(OE_AD1_N));
IOBUF_PCI33_5 XPCI_ADB12 (.O(AD_IN12),.IO(AD[12]),.I(AD_O12),.T(OE_AD1_N));
IOBUF_PCI33_5 XPCI_ADB11 (.O(AD_IN11),.IO(AD[11]),.I(AD_O11),.T(OE_AD1_N));
IOBUF_PCI33_5 XPCI_ADB10 (.O(AD_IN10),.IO(AD[10]),.I(AD_O10),.T(OE_AD1_N));
IOBUF_PCI33_5 XPCI_ADB9  (.O(AD_IN9 ),.IO(AD[9 ]),.I(AD_O9 ),.T(OE_AD1_N));
IOBUF_PCI33_5 XPCI_ADB8  (.O(AD_IN8 ),.IO(AD[8 ]),.I(AD_O8 ),.T(OE_AD1_N));

IOBUF_PCI33_5 XPCI_ADB7  (.O(AD_IN7 ),.IO(AD[7 ]),.I(AD_O7 ),.T(OE_AD0_N));
IOBUF_PCI33_5 XPCI_ADB6  (.O(AD_IN6 ),.IO(AD[6 ]),.I(AD_O6 ),.T(OE_AD0_N));
IOBUF_PCI33_5 XPCI_ADB5  (.O(AD_IN5 ),.IO(AD[5 ]),.I(AD_O5 ),.T(OE_AD0_N));
IOBUF_PCI33_5 XPCI_ADB4  (.O(AD_IN4 ),.IO(AD[4 ]),.I(AD_O4 ),.T(OE_AD0_N));
IOBUF_PCI33_5 XPCI_ADB3  (.O(AD_IN3 ),.IO(AD[3 ]),.I(AD_O3 ),.T(OE_AD0_N));
IOBUF_PCI33_5 XPCI_ADB2  (.O(AD_IN2 ),.IO(AD[2 ]),.I(AD_O2 ),.T(OE_AD0_N));
IOBUF_PCI33_5 XPCI_ADB1  (.O(AD_IN1 ),.IO(AD[1 ]),.I(AD_O1 ),.T(OE_AD0_N));
IOBUF_PCI33_5 XPCI_ADB0  (.O(AD_IN0 ),.IO(AD[0 ]),.I(AD_O0 ),.T(OE_AD0_N));

// input flipflops
FDPE XPCI_ADIQ31 (.Q(AD_I31),.D(AD_IN31),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ30 (.Q(AD_I30),.D(AD_IN30),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ29 (.Q(AD_I29),.D(AD_IN29),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ28 (.Q(AD_I28),.D(AD_IN28),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ27 (.Q(AD_I27),.D(AD_IN27),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ26 (.Q(AD_I26),.D(AD_IN26),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ25 (.Q(AD_I25),.D(AD_IN25),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ24 (.Q(AD_I24),.D(AD_IN24),.C(CLK),.CE(1'b1),.PRE(RST));

FDPE XPCI_ADIQ23 (.Q(AD_I23),.D(AD_IN23),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ22 (.Q(AD_I22),.D(AD_IN22),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ21 (.Q(AD_I21),.D(AD_IN21),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ20 (.Q(AD_I20),.D(AD_IN20),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ19 (.Q(AD_I19),.D(AD_IN19),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ18 (.Q(AD_I18),.D(AD_IN18),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ17 (.Q(AD_I17),.D(AD_IN17),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ16 (.Q(AD_I16),.D(AD_IN16),.C(CLK),.CE(1'b1),.PRE(RST));

FDPE XPCI_ADIQ15 (.Q(AD_I15),.D(AD_IN15),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ14 (.Q(AD_I14),.D(AD_IN14),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ13 (.Q(AD_I13),.D(AD_IN13),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ12 (.Q(AD_I12),.D(AD_IN12),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ11 (.Q(AD_I11),.D(AD_IN11),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ10 (.Q(AD_I10),.D(AD_IN10),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ9  (.Q(AD_I9 ),.D(AD_IN9 ),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ8  (.Q(AD_I8 ),.D(AD_IN8 ),.C(CLK),.CE(1'b1),.PRE(RST));

FDPE XPCI_ADIQ7  (.Q(AD_I7 ),.D(AD_IN7 ),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ6  (.Q(AD_I6 ),.D(AD_IN6 ),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ5  (.Q(AD_I5 ),.D(AD_IN5 ),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ4  (.Q(AD_I4 ),.D(AD_IN4 ),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ3  (.Q(AD_I3 ),.D(AD_IN3 ),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ2  (.Q(AD_I2 ),.D(AD_IN2 ),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ1  (.Q(AD_I1 ),.D(AD_IN1 ),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_ADIQ0  (.Q(AD_I0 ),.D(AD_IN0 ),.C(CLK),.CE(1'b1),.PRE(RST));

IOBUF_PCI33_5 XPCI_CBB3 (.O(CBE_IN3),.IO(CBE_N[3]),.I(CBE_O3),.T(OE_CBE_N  ));
IOBUF_PCI33_5 XPCI_CBB2 (.O(CBE_IN2),.IO(CBE_N[2]),.I(CBE_O2),.T(OE_CBE_N  ));
IOBUF_PCI33_5 XPCI_CBB1 (.O(CBE_IN1),.IO(CBE_N[1]),.I(CBE_O1),.T(OE_CBE_N  ));
IOBUF_PCI33_5 XPCI_CBB0 (.O(CBE_IN0),.IO(CBE_N[0]),.I(CBE_O0),.T(OE_CBE_N  ));
// input flipflops
FDPE XPCI_CBIQ3 (.Q(CBE_I3),.D(CBE_IN3),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_CBIQ2 (.Q(CBE_I2),.D(CBE_IN2),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_CBIQ1 (.Q(CBE_I1),.D(CBE_IN1),.C(CLK),.CE(1'b1),.PRE(RST));
FDPE XPCI_CBIQ0 (.Q(CBE_I0),.D(CBE_IN0),.C(CLK),.CE(1'b1),.PRE(RST));


IOBUF_PCI33_5 XPCI_PAR      (.O(PAR_IN),.IO(PAR),
                             .I(PAR_O),.T(OE_PAR_N));
// input flipflops
FDPE XPCI_PARIQ (.Q(PAR_I),.D(PAR_IN),.C(CLK),.CE(1'b1),.PRE(RST));									  


IOBUF_PCI33_5 XPCI_FRAME    (.O(FRAME_IN),.IO(FRAME_N),
                             .I(FRAME_O_N),.T(OE_FRAME_N));
// input flipflop
FDPE XPCI_FRAMEIQ (.Q(FRAME_I_N),.D(FRAME_IN),.C(CLK),.CE(1'b1),.PRE(RST));									  


IOBUF_PCI33_5 XPCI_TRDY     (.O(TRDY_IN),.IO(TRDY_N),
                             .I(TRDY_O_N),.T(OE_TRDY_N));
// input flipflop
FDPE XPCI_TRDYIQ (.Q(TRDY_I_N),.D(TRDY_IN),.C(CLK),.CE(1'b1),.PRE(RST));									  


IOBUF_PCI33_5 XPCI_IRDY     (.O(IRDY_IN),.IO(IRDY_N),
                             .I(IRDY_O_N),.T(OE_IRDY_N));
// input flipflop
FDPE XPCI_IRDYIQ (.Q(IRDY_I_N),.D(IRDY_IN),.C(CLK),.CE(1'b1),.PRE(RST));									  


IOBUF_PCI33_5 XPCI_STOP     (.O(STOP_IN),.IO(STOP_N),
                             .I(STOP_O_N),.T(OE_STOP_N));
// input flipflop
FDPE XPCI_STOPIQ (.Q(STOP_I_N),.D(STOP_IN),.C(CLK),.CE(1'b1),.PRE(RST));									  


IOBUF_PCI33_5 XPCI_DEVSEL   (.O(DEVSEL_IN),.IO(DEVSEL_N),
                             .I(DEVSEL_O_N),.T(OE_DEVSEL_N));
// input flipflop
FDPE XPCI_DEVSELIQ (.Q(DEVSEL_I_N),.D(DEVSEL_IN),.C(CLK),.CE(1'b1),.PRE(RST));									  


IOBUF_PCI33_5 XPCI_PERR     (.O(PERR_IN),.IO(PERR_N),
                             .I(PERR_O_N),.T(OE_PERR_N));
// input flipflop
FDPE XPCI_PERRIQ (.Q(PERR_I_N),.D(PERR_IN),.C(CLK),.CE(1'b1),.PRE(RST));									  
									  

IOBUF_PCI33_5 XPCI_SERR     (.O(SERR_IN),.IO(SERR_N),
                             .I( 1'b0 ),.T(OE_SERR_N));
// input flipflop
FDPE XPCI_SERRIQ (.Q(SERR_I_N),.D(SERR_IN),.C(CLK),.CE(1'b1),.PRE(RST));									  

//									  
// outputs only
//
OBUFT_PCI33_5 XPCI_REQ      (.O(REQ_N),.T(OE_REQ_N),.I(1'b0));

OBUFT_PCI33_5 XPCI_INTA     (.O(INTA_N),.T(OE_INTA_N),.I(1'b0));
// interrupt is asynchronous, so need no flipflop.

//
// inputs only
//
IBUF_PCI33_5  XPCI_IDSEL    (.O(IDSEL_IN),.I(IDSEL));
// input flipflop
FDPE XPCI_IDSELIQ (.Q(IDSEL_I),.D(IDSEL_IN),.C(CLK),.CE(1'b1),.PRE(RST));

IBUF_PCI33_5  XPCI_GNT      (.O(GNT_IN),.I(GNT_N));
// input flipflop
FDPE XPCI_GNTIQ (.Q(GNT_I_N),.D(GNT_IN),.C(CLK),.CE(1'b1),.PRE(RST));



// instantiate our PCI interface implementation
PCI PCI(
	.AD_I({AD_I31, AD_I30, AD_I29, AD_I28, AD_I27, AD_I26, AD_I25, AD_I24, AD_I23, AD_I22, AD_I21, AD_I20, AD_I19, AD_I18, AD_I17, AD_I16, AD_I15, AD_I14, AD_I13, AD_I12, AD_I11, AD_I10, AD_I9, AD_I8, AD_I7, AD_I6, AD_I5, AD_I4, AD_I3, AD_I2, AD_I1, AD_I0}),
	.AD_O({AD_O31, AD_O30, AD_O29, AD_O28, AD_O27, AD_O26, AD_O25, AD_O24, AD_O23, AD_O22, AD_O21, AD_O20, AD_O19, AD_O18, AD_O17, AD_O16, AD_O15, AD_O14, AD_O13, AD_O12, AD_O11, AD_O10, AD_O9, AD_O8, AD_O7, AD_O6, AD_O5, AD_O4, AD_O3, AD_O2, AD_O1, AD_O0}),
	.OE_AD_N({OE_AD3_N, OE_AD2_N, OE_AD1_N, OE_AD0_N}),
   .CBE_I({CBE_I3, CBE_I2, CBE_I1, CBE_I0}),
   .CBE_O({CBE_O3, CBE_O2, CBE_O1, CBE_O0}),
	.OE_CBE_N(OE_CBE_N),
	.PAR_I(PAR_I),
	.PAR_O(PAR_O),
	.OE_PAR_N(OE_PAR_N),
	.FRAME_I_N(FRAME_I_N),
	.FRAME_O_N(FRAME_O_N),
	.OE_FRAME_N(OE_FRAME_N),
	.TRDY_I_N(TRDY_I_N),
	.TRDY_O_N(TRDY_O_N),
	.OE_TRDY_N(OE_TRDY_N),
	.IRDY_I_N(IRDY_I_N),
	.IRDY_O_N(IRDY_O_N),
	.OE_IRDY_N(OE_IRDY_N),
	.STOP_I_N(STOP_I_N),
	.STOP_O_N(STOP_O_N),
	.OE_STOP_N(OE_STOP_N),
	.DEVSEL_I_N(DEVSEL_I_N),
	.DEVSEL_O_N(DEVSEL_O_N),
	.OE_DEVSEL_N(OE_DEVSEL_N),
	.IDSEL_I(IDSEL_I),
	.PERR_I_N(PERR_I_N),
	.PERR_O_N(PERR_O_N),	
	.OE_PERR_N(OE_PERR_N),
	.SERR_I_N(SERR_I_N),
	.OE_SERR_N(OE_SERR_N),
	.OE_REQ_N(OE_REQ_N),	
	.GNT_I_N(GNT_I_N),
   .CLK(CLK),
	.OE_INTA_N(OE_INTA_N),
   .PING_DONE(PING_DONE),
	.RST(RST),
	.IRDY_IN(IRDY_IN),
	.TRDY_IN(TRDY_IN)	
);

endmodule
