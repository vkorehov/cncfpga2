/***********************************************************************
 
  File:   dumb_arbiter.v
  Rev:    3.1.166

  This is a functional simulation model for a simple arbiter.  This
  is not synthesizable.  This file is only for simulation.

  Copyright (c) 2005-2008 Xilinx, Inc.  All rights reserved.

***********************************************************************/


module dumb_arbiter (
                REQ_N, 
                GNT_N,
                SINGLE,
                PARK,
                CLK
                );

  input         REQ_N;
  output        GNT_N;
  input         SINGLE;
  input         PARK;
  input         CLK;


  parameter     TGNT = 5;


  reg           req_n_delayed;
  reg           grant_n;
  wire          one_shot;

  initial req_n_delayed = 1'b1;
  always @(posedge CLK) req_n_delayed = REQ_N;

  assign #TGNT one_shot = REQ_N | !req_n_delayed;

  initial grant_n = 1'b1;
  always @(posedge CLK)
  begin
    if (PARK) grant_n = 1'b0;
    else if (SINGLE) grant_n = one_shot;
    else grant_n = REQ_N;
  end

  assign #TGNT GNT_N = grant_n;


endmodule
