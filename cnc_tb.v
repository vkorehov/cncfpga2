/***********************************************************************

  File:   ping_tb.v
  Rev:    3.1.166

  This is an example top-level verilog testbench for the Ping user
  design.  It instantiates the Ping design, behavioral arbiter and
  target, and stimulus.  The design of individual components may be
  customized without affecting the top level.

  Copyright (c) 2005-2008 Xilinx, Inc.  All rights reserved.

***********************************************************************/

`timescale 1 ns / 1 ps

module cnc_tb;


  // PCI Bus Signals

  wire   [31:0] AD;
  wire    [3:0] CBE;
  wire          PAR;
  tri1          FRAME_N;
  tri1          TRDY_N;
  tri1          IRDY_N;
  tri1          STOP_N;
  tri1          DEVSEL_N;
  wire          IDSEL;
  tri1          INTR_A;
  tri1          PERR_N;
  tri1          SERR_N;
  tri1          REQ_N;
  tri1          GNT_N;
  wire          RST_N;
  wire          CLK;

  wire          SINGLE;
  wire          PARK;
  wire          PING_DONE;
  wire          PING_REQUEST32;


  // Instantiate master stimulus device

  stimulus STM (
                .AD( AD ),
                .CBE( CBE ),
                .PAR( PAR ),
                .FRAME_N( FRAME_N ),
                .TRDY_N( TRDY_N ),
                .IRDY_N( IRDY_N ),
                .STOP_N( STOP_N ),
                .DEVSEL_N( DEVSEL_N ),
                .IDSEL( IDSEL ),
                .INTR_A( INTR_A ),
                .PERR_N( PERR_N ),
                .SERR_N( SERR_N ),
                .RST_N( RST_N ),
                .CLK( CLK ),
                .SINGLE( SINGLE ),
                .PARK( PARK ),
                .PING_DONE( PING_DONE ),
                .PING_REQUEST32( PING_REQUEST32 )
                );


  // Instantiate arbiter

  dumb_arbiter ARB (
                .REQ_N( REQ_N ),
                .GNT_N( GNT_N ),
                .SINGLE( SINGLE ),
                .PARK( PARK ),
                .CLK( CLK )
                );


  // Instantiate FPGA PCI design

  cnc_top UUT (
                .AD( AD ),
                .CBE( CBE ),
                .PAR( PAR ),
                .FRAME_N( FRAME_N ),
                .TRDY_N( TRDY_N ),
                .IRDY_N( IRDY_N ),
                .STOP_N( STOP_N ),
                .DEVSEL_N( DEVSEL_N ),
                .IDSEL( IDSEL ),
                .INTR_A( INTR_A ),
                .PERR_N( PERR_N ),
                .SERR_N( SERR_N ),
                .REQ_N( REQ_N ),
                .GNT_N( GNT_N ),
                .RST_N( RST_N ),
                .PCLK( CLK ),
                .PING_DONE( PING_DONE ),
                .PING_REQUEST32( PING_REQUEST32 )
                );


  // Instantiate a 32-bit Target

  dumb_target32 TRG32 (
                .AD( AD[31:0] ),
                .CBE( CBE[3:0] ),
                .PAR( PAR ),
                .FRAME_N( FRAME_N ),
                .TRDY_N( TRDY_N ),
                .IRDY_N( IRDY_N ),
                .STOP_N( STOP_N ),
                .DEVSEL_N( DEVSEL_N ),
                .RST_N( RST_N ),
                .CLK( CLK )
                );


  // Start the simulation history manager.

  initial
  begin
    $shm_open("waves.shm");
    $shm_probe("AC");
  end


  // Instantiate a Bus Recorder

  busrecord REC (
                .AD( AD ),
                .CBE( CBE ),
                .PAR( PAR ),
                .FRAME_N( FRAME_N ),
                .TRDY_N( TRDY_N ),
                .IRDY_N( IRDY_N ),
                .STOP_N( STOP_N ),
                .DEVSEL_N( DEVSEL_N ),
                .IDSEL( IDSEL ),
                .INTR_A( INTR_A ),
                .PERR_N( PERR_N ),
                .SERR_N( SERR_N ),
                .REQ_N( REQ_N ),
                .GNT_N( GNT_N ),
                .RST_N( RST_N ),
                .CLK( CLK )
                );


endmodule
