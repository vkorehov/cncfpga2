/***********************************************************************
 
  File:   dumb_targ32.v
  Rev:    3.1.166

  This is a functional simulation model for a simple target.  This
  is not synthesizable.  This file is only for simulation.

  Copyright (c) 2005-2008 Xilinx, Inc.  All rights reserved.

***********************************************************************/


// Module Declaration

module dumb_target32 (
                AD,
                CBE,
                PAR,
                FRAME_N,
                TRDY_N,
                IRDY_N,
                STOP_N,
                DEVSEL_N,
                RST_N,
                CLK
                );


  // Port Directions

  inout  [31:0] AD;
  inout   [3:0] CBE;
  inout         PAR;
  inout         FRAME_N;
  inout         TRDY_N;
  inout         IRDY_N;
  inout         STOP_N;
  inout         DEVSEL_N;
  input         RST_N;
  input         CLK;


  // Some signals and variables
 
  reg    [31:0] cmd_mem [0:31];
  integer       loop_var;
  parameter     TDEL = 5;

 
  // Deal With Reset
 
  always @(posedge RST_N)
  begin
    for (loop_var = 0; loop_var < 32; loop_var = loop_var + 1)
    begin
      cmd_mem[loop_var] = {loop_var[7:0], 16'h0000, loop_var[7:0]};
    end
  end 
 

  // Signals the target is responsible for driving

  reg    [31:0] reg_ad;
  reg           ad_oe;
  reg     [3:0] reg_cbe;
  reg           cbe_oe;
  reg           reg_par;
  reg           par_oe;

  reg           reg_frame_n;
  reg           frame_oe;
  reg           reg_irdy_n;
  reg           irdy_oe;
  reg           reg_trdy_n;
  reg           trdy_oe;
  reg           reg_stop_n;
  reg           stop_oe;
  reg           reg_devsel_n;
  reg           devsel_oe;


  // Define port hookup
 
  assign #TDEL AD = ad_oe ? reg_ad : 32'bz;
  assign #TDEL CBE = cbe_oe ? reg_cbe : 4'bz;
  assign #TDEL PAR = par_oe ? reg_par : 1'bz;
  assign #TDEL FRAME_N = frame_oe ? reg_frame_n : 1'bz;
  assign #TDEL IRDY_N = irdy_oe ? reg_irdy_n : 1'bz;
  assign #TDEL TRDY_N = trdy_oe ? reg_trdy_n : 1'bz;
  assign #TDEL STOP_N = stop_oe ? reg_stop_n : 1'bz;
  assign #TDEL DEVSEL_N = devsel_oe ? reg_devsel_n : 1'bz;


  // PCI Parity Generation

  always @(posedge CLK)
  begin
    // Always computed, selectively enabled
    reg_par <= (^ {AD, CBE});
  end

  wire drive;

  assign #TDEL drive = ad_oe;

  always @(posedge CLK)
  begin
    par_oe <= drive;
  end


  // Default PCI bus conditions

  initial
  begin
    reg_ad = 32'h00000000;
    ad_oe = 1'b0;
    reg_cbe = 4'h0;
    cbe_oe = 1'b0;
    reg_frame_n = 1'b1;
    frame_oe = 1'b0;
    reg_irdy_n = 1'b1;
    irdy_oe = 1'b0;
    reg_trdy_n = 1'b1;
    trdy_oe = 1'b0;
    reg_stop_n = 1'b1;
    stop_oe = 1'b0;
    reg_devsel_n = 1'b1;
    devsel_oe = 1'b0;
  end


  // The actual target stuff begins here

  reg    [31:0] counter;
  reg           old_frame_n;
  reg           cmd_write;
  reg           cmd_read;
  wire          valid_read;
  wire          valid_write;

  assign #TDEL valid_write = (CBE == 4'b0111) ;

  assign #TDEL valid_read  = (CBE == 4'b0110) ||
                             (CBE == 4'b1100) ||
                             (CBE == 4'b1110) ;



  always @(posedge CLK)
  begin
    if(!RST_N)                                  // PCI Bus reset
    begin
      reg_ad = 32'h0;
      ad_oe = 1'b0;
      reg_cbe = 4'h0;
      cbe_oe = 1'b0;
      reg_frame_n = 1'b1;
      frame_oe = 1'b0;
      reg_irdy_n = 1'b1;
      irdy_oe = 1'b0;
      reg_trdy_n = 1'b1;
      trdy_oe = 1'b0;
      reg_stop_n = 1'b1;
      stop_oe = 1'b0;
      reg_devsel_n = 1'b1;
      devsel_oe = 1'b0;
      old_frame_n = 1'b1;
    end
    else NORMAL;
  end


  task NORMAL;
    begin
      if (old_frame_n && !FRAME_N && (valid_read || valid_write)
          && (AD[31:16] == 16'h4000))
      begin
        old_frame_n = 1'b0;
        devsel_oe = 1'b1;
        stop_oe = 1'b1;
        trdy_oe = 1'b1;
        cmd_write = valid_write;
        cmd_read = valid_read;
        counter = (AD >> 2) & 32'h0000001f;
        reg_ad = cmd_mem[counter];

        if (valid_write)
        begin   
          reg_devsel_n = 1'b0;
          reg_stop_n = 1'b1;
          reg_trdy_n = 1'b0;
        end
        else
        begin
          reg_devsel_n = 1'b0;
          @(posedge CLK);
          reg_stop_n = 1'b1;
          reg_trdy_n = 1'b0;
          ad_oe = 1'b1;
        end

        while (!old_frame_n)
        begin
          @(posedge CLK);
          while (IRDY_N) @(posedge CLK);
          old_frame_n = FRAME_N;
          if (cmd_write) cmd_mem[counter] = AD;
          counter = (counter + 1) & 32'h0000001f;
          reg_ad = cmd_mem[counter];
        end

        ad_oe = 1'b0;
        reg_devsel_n = 1'b1;
        reg_stop_n = 1'b1;
        reg_trdy_n = 1'b1;
        @(posedge CLK);
        devsel_oe = 1'b0;
        stop_oe = 1'b0;
        trdy_oe = 1'b0;
        old_frame_n = 1'b1;
      end
    end
  endtask


endmodule
