/***********************************************************************
 
  File:   busrecord.v
  Rev:    3.1.166

  This module saves the state of the PCI bus signals into a file at
  every positive edge of the clock.  After simulation, the output
  file can be compared to a known good file to verify the sameness
  of two designs.

  Copyright (c) 2005-2008 Xilinx, Inc.  All rights reserved.

***********************************************************************/


module busrecord (
                AD,
                CBE,
                PAR,
                FRAME_N,
                TRDY_N,
                IRDY_N,
                STOP_N,
                DEVSEL_N,
                PERR_N,
                SERR_N,
                INTR_A,
                IDSEL,
                REQ_N,
                GNT_N,
                RST_N,
                CLK
                );


  // Port Directions

  input  [31:0] AD;
  input   [3:0] CBE;
  input         PAR;
  input         FRAME_N;
  input         TRDY_N;
  input         IRDY_N;
  input         STOP_N;
  input         DEVSEL_N;
  input         PERR_N;
  input         SERR_N;
  input         INTR_A;
  input         IDSEL;
  input         REQ_N;
  input         GNT_N;
  input         RST_N;
  input         CLK;
 

  integer       file_ptr;

  initial
  begin
    $timeformat(-9, 0, " NS", 0); 
    file_ptr = $fopen("waves.tbl"); 
  end


  always @(posedge CLK)
  begin
    $fdisplay(file_ptr,"%b %b %b %b %b %b %b %b %b %b %b %b %b %b %t",
              AD, CBE, PAR, FRAME_N, TRDY_N, IRDY_N, STOP_N, DEVSEL_N,
              PERR_N, SERR_N, INTR_A, IDSEL, REQ_N, GNT_N, $realtime);
  end


endmodule
