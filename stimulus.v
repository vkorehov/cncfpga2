/***********************************************************************

  File:   stimulus.v
  Rev:    3.1.166

  This is a functional simulation model for a stimulus generator.
  This is not synthesizable.  This file is only for simulation.

  Copyright (c) 2005-2008 Xilinx, Inc.  All rights reserved.

***********************************************************************/


module stimulus (
                AD,
                CBE,
                PAR,
                FRAME_N,
                TRDY_N,
                IRDY_N,
                STOP_N,
                DEVSEL_N,
                IDSEL,
                INTR_A,
                PERR_N,
                SERR_N,
                RST_N,
                CLK,
                SINGLE,
                PARK,
                PING_DONE,
                PING_REQUEST32
                );


  inout  [31:0] AD;
  inout   [3:0] CBE;
  inout         PAR;
  inout         FRAME_N;
  inout         TRDY_N;
  inout         IRDY_N;
  inout         STOP_N;
  inout         DEVSEL_N;
  output        IDSEL;
  input         INTR_A;
  input         PERR_N;
  input         SERR_N;
  output        RST_N;
  output        CLK;
  output        SINGLE;
  output        PARK;
  input         PING_DONE;
  output        PING_REQUEST32;


  // Define Timing Parameters

  parameter TCLKH = 15;
  parameter TCLKL = 15;
  parameter TDEL =  5;


  // Define Internal Registers

  reg           pciclk;
  reg           pciclk_en;
  reg  [8*12:1] operation;
  reg     [3:0] status_code;

  reg    [31:0] reg_ad;
  reg           ad_oe;
  reg     [3:0] reg_cbe;
  reg           cbe_oe;
  reg           reg_par;
  reg           par_oe;
  reg           reg_frame_n;
  reg           frame_oe;
  reg           reg_trdy_n;
  reg           trdy_oe;
  reg           reg_irdy_n;
  reg           irdy_oe;
  reg           reg_stop_n;
  reg           stop_oe;
  reg           reg_devsel_n;
  reg           devsel_oe;

  reg           reg_idsel;
  reg           reg_rst_n;
  reg           reg_single;
  reg           reg_park;
  reg           reg_req32;


  // Define port hookup

  assign #TDEL AD = ad_oe ? reg_ad : 32'bz;
  assign #TDEL CBE = cbe_oe ? reg_cbe : 4'bz;
  assign #TDEL PAR = par_oe ? reg_par : 1'bz;

  assign #TDEL FRAME_N = frame_oe ? reg_frame_n : 1'bz;
  assign #TDEL TRDY_N = trdy_oe ? reg_trdy_n : 1'bz;
  assign #TDEL IRDY_N = irdy_oe ? reg_irdy_n : 1'bz;
  assign #TDEL STOP_N = stop_oe ? reg_stop_n : 1'bz;
  assign #TDEL DEVSEL_N = devsel_oe ? reg_devsel_n : 1'bz;
  assign #TDEL IDSEL = reg_idsel;
  assign #TDEL RST_N = reg_rst_n;
  assign #TDEL SINGLE = reg_single;
  assign #TDEL PARK = reg_park;
  assign #TDEL PING_REQUEST32 = reg_req32;


  // Clock generation

  always
  begin
    pciclk <= 0;
    #TCLKL;
    pciclk <= pciclk_en;
    #TCLKH;
  end

  assign CLK = pciclk;


  // PCI Parity Generation

  always @(posedge pciclk)
  begin
    // Always computed, selectively enabled
    reg_par <= (^ {AD, CBE});
  end

  wire drive;

  assign #TDEL drive = ad_oe;

  always @(posedge pciclk)
  begin
    par_oe <= drive;
  end


  // Task for reading from the PCI32's configuration space

  task READ_CONFIG;
    input [31:0] address;
  begin
    $display(" ");
    $display("Reading Ping Config Reg...");
    operation <= "READ_CFG_32 ";
    @(posedge pciclk);
      reg_frame_n <= 0;
      reg_irdy_n <= 1;
      reg_ad <= address;
      reg_cbe <= 4'b1010;
      reg_idsel <= 1;
      frame_oe <= 1;
      irdy_oe <= 1;
      ad_oe <= 1;
      cbe_oe <= 1;
    @(posedge pciclk);
      reg_frame_n <= 1;
      reg_irdy_n <= 0;
      reg_cbe <= 4'b0000;
      reg_idsel <= 0;
      frame_oe <= 1;
      irdy_oe <= 1;
      ad_oe <= 0;
      cbe_oe <= 1;
      XFER_STATUS(0, status_code);
      reg_irdy_n <= 1;
      frame_oe <= 0;
      irdy_oe <= 1;
      ad_oe <= 0;
      cbe_oe <= 0;
    @(posedge pciclk);
      frame_oe <= 0;
      irdy_oe <= 0;
    @(posedge pciclk);
    INTERCYCLE_GAP;
  end
  endtask


  // Task for writing to the PCI32's configuration space

  task WRITE_CONFIG;
    input [31:0] address;
    input [31:0] data;
  begin
    $display(" ");
    $display("Writing Ping Config Reg...");
    operation <= "WRITE_CFG_32";
    @(posedge pciclk);
      reg_frame_n <= 0;
      reg_irdy_n <= 1;
      reg_ad <= address;
      reg_cbe <= 4'b1011;
      reg_idsel <= 1;
      frame_oe <= 1;
      irdy_oe <= 1;
      ad_oe <= 1;
      cbe_oe <= 1;
    @(posedge pciclk);
      reg_frame_n <= 1;
      reg_irdy_n <= 0;
      reg_ad <= data;
      reg_cbe <= 4'b0000;
      reg_idsel <= 0;
      frame_oe <= 1;
      irdy_oe <= 1;
      ad_oe <= 1;
      cbe_oe <= 1;
      XFER_STATUS(1, status_code);
      reg_irdy_n <= 1;
      frame_oe <= 0;
      irdy_oe <= 1;
      ad_oe <= 0;
      cbe_oe <= 0;
    @(posedge pciclk);
      frame_oe <= 0;
      irdy_oe <= 0;
    @(posedge pciclk);
    INTERCYCLE_GAP;
  end
  endtask


  // Task for reading from the PCI32

  task READ32;
    input  [3:0] command;
    input [31:0] address;
  begin
    $display(" ");
    $display("Reading Ping...");
    operation <= "READ_PNG_32 ";
    @(posedge pciclk);
      reg_frame_n <= 0;
      reg_irdy_n <= 1;
      reg_ad <= address;
      reg_cbe <= command;
      frame_oe <= 1;
      irdy_oe <= 1;
      ad_oe <= 1;
      cbe_oe <= 1;
    @(posedge pciclk);
      reg_frame_n <= 1;
      reg_irdy_n <= 0;
      reg_cbe <= 4'b0000;
      frame_oe <= 1;
      irdy_oe <= 1;
      ad_oe <= 0;
      cbe_oe <= 1;
      XFER_STATUS(0, status_code);
      reg_irdy_n <= 1;
      frame_oe <= 0;
      irdy_oe <= 1;
      ad_oe <= 0;
      cbe_oe <= 0;
    @(posedge pciclk);
      frame_oe <= 0;
      irdy_oe <= 0;
    @(posedge pciclk);
    INTERCYCLE_GAP;
  end
  endtask


  // Task for writing to the PCI32

  task WRITE32;
    input  [3:0] command;
    input [31:0] address;
    input [31:0] data;
  begin
    $display(" ");
    $display("Writing Ping...");
    operation <= "WRITE_PNG_32";
    @(posedge pciclk);
      reg_frame_n <= 0;
      reg_irdy_n <= 1;
      reg_ad <= address;
      reg_cbe <= command;
      frame_oe <= 1;
      irdy_oe <= 1;
      ad_oe <= 1;
      cbe_oe <= 1;
    @(posedge pciclk);
      reg_frame_n <= 1;
      reg_irdy_n <= 0;
      reg_ad <= data;
      reg_cbe <= 4'b0000;
      frame_oe <= 1;
      irdy_oe <= 1;
      ad_oe <= 1;
      cbe_oe <= 1;
      XFER_STATUS(1, status_code);
      reg_irdy_n <= 1;
      frame_oe <= 0;
      irdy_oe <= 1;
      ad_oe <= 0;
      cbe_oe <= 0;
    @(posedge pciclk);
      frame_oe <= 0;
      irdy_oe <= 0;
    @(posedge pciclk);
    INTERCYCLE_GAP;
  end
  endtask


  // Task for monitoring the actual data transfer

  task XFER_STATUS;
    input write_read;
    output [3:0] return_stat;
    integer devsel_cnt;
    integer trdy_cnt;
  begin
    devsel_cnt = 0;
    trdy_cnt = 0;
    while(DEVSEL_N && (devsel_cnt < 10))
    begin
      @(posedge pciclk);
      devsel_cnt = devsel_cnt + 1; // increment count
    end
    while(TRDY_N  && STOP_N && ((trdy_cnt < 16) && (devsel_cnt < 10)))
    begin
      trdy_cnt = trdy_cnt + 1;
      @(posedge pciclk);
    end
    if (devsel_cnt < 10)
      begin
        if (trdy_cnt <= 16)
          begin
            if (TRDY_N == 0 && STOP_N == 1)
            begin
              if (write_read)
                $display("  STM-->PNG: Normal Termination, Data Transferred");
              else
                $display("  STM<--PNG: Normal Termination, Data Transferred");
              return_stat = 1;
            end
            else if(TRDY_N == 0 && STOP_N == 0)
            begin
              if (write_read)
                $display("  STM-->PNG: Disconnect, Data Transferred");
              else
                $display("  STM<--PNG: Disconnect, Data Transferred");
              return_stat = 2;
            end
            else if (TRDY_N==1 && STOP_N == 0 && DEVSEL_N == 0)
            begin
              if (write_read)
                $display("  STM-->PNG: Retry, No Data Transferred");
              else
                $display("  STM<--PNG: Retry, No Data Transferred");
              return_stat = 3;
            end
            else if (TRDY_N==1 && STOP_N == 0 && DEVSEL_N == 1)
            begin
              if (write_read)
                $display("  STM-->PNG: Target Abort, No Data Transferred");
              else
                $display("  STM<--PNG: Target Abort, No Data Transferred");
              return_stat = 4;
            end
            else if (TRDY_N==1 && STOP_N == 1)
            begin
              $display("  ERROR: Check Transfer Procedure");
              return_stat = 5;
            end
          end
        else
        begin
          $display("  ERROR: No Target Response");
          return_stat = 6;
        end
      end
    else
    begin
      $display("  ERROR: Master Abort");
      return_stat = 7;
    end
  end
  endtask


  // Task for waiting

  task INTERCYCLE_GAP;
  begin
    @(posedge pciclk);
    @(posedge pciclk);
    @(posedge pciclk);
    @(posedge pciclk);
  end
  endtask


  // Task for starting 32-bit transfer

  task MOVE32;
  begin
    @(posedge pciclk);
    reg_req32 <= 1'b1;
    @(posedge pciclk);
    reg_req32 <= 1'b0;
    @(posedge pciclk);
    wait (PING_DONE);
    @(posedge pciclk);
  end
  endtask


  // Tasks for bus parking

  task ARB_PARK;
  begin
    @(posedge pciclk);
    reg_park <= 1'b1;
    @(posedge pciclk);
  end
  endtask

  task ARB_FREE;
  begin
    @(posedge pciclk);
    reg_park <= 1'b0;
    @(posedge pciclk);
  end
  endtask


  // Tasks for single cycle grants

  task ARB_SINGLE;
  begin
    @(posedge pciclk);
    reg_single <= 1'b1;
    @(posedge pciclk);
  end
  endtask

  task ARB_FOLLOW;
  begin
    @(posedge pciclk);
    reg_single <= 1'b0;
    @(posedge pciclk);
  end
  endtask


  // Begin the actual simulation sequence

  initial
  begin
    // start by setting up all signals
    operation <= "SYSTEM RESET";
    pciclk_en <= 1;
    reg_ad <= 32'h0;
    ad_oe <= 0;
    reg_cbe <= 4'h0;
    cbe_oe <= 0;
    reg_frame_n <= 1;
    frame_oe <= 0;
    reg_trdy_n <= 1;
    trdy_oe <= 0;
    reg_irdy_n <= 1;
    irdy_oe <= 0;
    reg_stop_n <= 1;
    stop_oe <= 0;
    reg_devsel_n <= 1;
    devsel_oe <= 0;
    reg_idsel <= 0;
    reg_rst_n <= 0;
    reg_single <= 0;
    reg_park <= 0;
    reg_req32 <= 0;

    // release system reset
    INTERCYCLE_GAP;
    reg_rst_n <= 1;
    $display("");
    $display("---------------------------");
    $display("Timing checks are not valid");
    $display("---------------------------");
    $display("While the system is coming out of reset, some settling");
    $display("of internal state may occur across clock edges, causing");
    $display("the simulator to report false timing violations. These");
    $display("may be safely ignored.");
    $display("");
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    $display(" ");
    $display("System Reset Complete...");
    $display(" ");
    $display("-----------------------");
    $display("Timing checks are valid");
    $display("-----------------------");
    $display("The system has now settled out of reset; timing checks");
    $display("are valid from this point on.");
    $display(" ");


    // read device and vendor id
    READ_CONFIG(32'h00000000);

    // write latency timer
    WRITE_CONFIG(32'h0000000c, 32'h0000ff00);
    READ_CONFIG(32'h0000000c);


    // setup io base address register
    WRITE_CONFIG(32'h00000010, 32'h10000000);
    READ_CONFIG(32'h00000010);

    // setup mem32 base address register
    WRITE_CONFIG(32'h00000014, 32'h20000000);
    READ_CONFIG(32'h00000014);

    // setup command register to enable mastering
    WRITE_CONFIG(32'h00000004, 32'hff000147);
    READ_CONFIG(32'h00000004);


    // read io space
    READ32(4'b0010, 32'h10000000);

    // write io space
    WRITE32(4'b0011, 32'h10000000, 32'h20202020);
    READ32(4'b0010, 32'h10000000);


    // read mem32 space
    READ32(4'b0110, 32'h20000000);

    // write mem32 space
    WRITE32(4'b0111, 32'h20000000, 32'h16161616);
    READ32(4'b0110, 32'h20000000);


    $display(" ");
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    $display(" ");
    $display("Performing 32-bit initiator transfers...");
    $display(" ");


    // set up one-dataphase 32-bit initiator  read to 32-bit target
    WRITE32(4'b0011, 32'h10000000, 32'h00000061);
    WRITE32(4'b0111, 32'h20000000, 32'h40000004);
    MOVE32;

    // set up two-dataphase 32-bit initiator  read to 32-bit target
    WRITE32(4'b0011, 32'h10000000, 32'h00000062);
    WRITE32(4'b0111, 32'h20000000, 32'h40000008);
    MOVE32;

    // set up three-dataphase 32-bit initiator  read to 32-bit target
    WRITE32(4'b0011, 32'h10000000, 32'h00000063);
    WRITE32(4'b0111, 32'h20000000, 32'h40000010);
    MOVE32;

    // set up four-dataphase 32-bit initiator  read to 32-bit target
    WRITE32(4'b0011, 32'h10000000, 32'h00000064);
    WRITE32(4'b0111, 32'h20000000, 32'h4000001c);
    MOVE32;

    // set up one-dataphase 32-bit initiator write to 32-bit target
    WRITE32(4'b0011, 32'h10000000, 32'h80000061);
    WRITE32(4'b0111, 32'h20000000, 32'h40000004);
    MOVE32;

    // set up two-dataphase 32-bit initiator write to 32-bit target
    WRITE32(4'b0011, 32'h10000000, 32'h80000062);
    WRITE32(4'b0111, 32'h20000000, 32'h40000008);
    MOVE32;

    // set up three-dataphase 32-bit initiator write to 32-bit target
    WRITE32(4'b0011, 32'h10000000, 32'h80000063);
    WRITE32(4'b0111, 32'h20000000, 32'h40000010);
    MOVE32;

    // set up four-dataphase 32-bit initiator write to 32-bit target
    WRITE32(4'b0011, 32'h10000000, 32'h80000064);
    WRITE32(4'b0111, 32'h20000000, 32'h4000001c);
    MOVE32;


    $display(" ");
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    $display(" ");
    $display("Performing 32-bit initiator transfers from park...");
    $display(" ");


    // set up one-dataphase 32-bit initiator  read to 32-bit target
    WRITE32(4'b0011, 32'h10000000, 32'h00000061);
    WRITE32(4'b0111, 32'h20000000, 32'h40000044);
    ARB_PARK;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    MOVE32;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    ARB_FREE;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;

    // set up two-dataphase 32-bit initiator  read to 32-bit target
    WRITE32(4'b0011, 32'h10000000, 32'h00000062);
    WRITE32(4'b0111, 32'h20000000, 32'h40000048);
    ARB_PARK;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    MOVE32;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    ARB_FREE;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;

    // set up three-dataphase 32-bit initiator  read to 32-bit target
    WRITE32(4'b0011, 32'h10000000, 32'h00000063);
    WRITE32(4'b0111, 32'h20000000, 32'h40000050);
    ARB_PARK;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    MOVE32;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    ARB_FREE;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;

    // set up four-dataphase 32-bit initiator  read to 32-bit target
    WRITE32(4'b0011, 32'h10000000, 32'h00000064);
    WRITE32(4'b0111, 32'h20000000, 32'h4000005c);
    ARB_PARK;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    MOVE32;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    ARB_FREE;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;

    // set up one-dataphase 32-bit initiator write to 32-bit target
    WRITE32(4'b0011, 32'h10000000, 32'h80000061);
    WRITE32(4'b0111, 32'h20000000, 32'h40000044);
    ARB_PARK;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    MOVE32;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    ARB_FREE;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;

    // set up two-dataphase 32-bit initiator write to 32-bit target
    WRITE32(4'b0011, 32'h10000000, 32'h80000062);
    WRITE32(4'b0111, 32'h20000000, 32'h40000048);
    ARB_PARK;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    MOVE32;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    ARB_FREE;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;

    // set up three-dataphase 32-bit initiator write to 32-bit target
    WRITE32(4'b0011, 32'h10000000, 32'h80000063);
    WRITE32(4'b0111, 32'h20000000, 32'h40000050);
    ARB_PARK;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    MOVE32;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    ARB_FREE;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;

    // set up four-dataphase 32-bit initiator write to 32-bit target
    WRITE32(4'b0011, 32'h10000000, 32'h80000064);
    WRITE32(4'b0111, 32'h20000000, 32'h4000005c);
    ARB_PARK;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    MOVE32;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    ARB_FREE;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;


    $display(" ");
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    INTERCYCLE_GAP;
    $display(" ");
    $display("Simulation complete...");
    $display(" ");

    // disable pciclk
    pciclk_en <= 0;

    // stop simulation
    $finish;
  end


endmodule
