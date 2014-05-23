/***********************************************************************

  File:   ping.v
  Rev:    3.1.166

  This is an example user application for use with the Xilinx PCI core.

  Copyright (c) 2005-2008 Xilinx, Inc.  All rights reserved.

***********************************************************************/


module cnc (
                FRAMEQ_N,
                TRDYQ_N,
                IRDYQ_N,
                STOPQ_N,
                DEVSELQ_N,
                ADDR,
                ADIO,
                CFG_VLD,
                CFG_HIT,
                C_TERM,
                C_READY,
                ADDR_VLD,
                BASE_HIT,
                S_TERM,
                S_READY,
                S_ABORT,
                S_WRDN,
                S_SRC_EN,
                S_DATA_VLD,
                S_CBE,
                PCI_CMD,
                REQUEST,
                REQUESTHOLD,
                COMPLETE,
                M_WRDN,
                M_READY,
                M_SRC_EN,
                M_DATA_VLD,
                M_CBE,
                TIME_OUT,
                CFG_SELF,
                M_DATA,
                DR_BUS,
                I_IDLE,
                M_ADDR_N,
                IDLE,
                B_BUSY,
                S_DATA,
                BACKOFF,
                INTR_N,
                PERRQ_N,
                SERRQ_N,
                KEEPOUT,
                CSR,
                SUB_DATA,
                CFG,
                RST,
                CLK,
                PING_DONE,
                PING_REQUEST32
                );
                // synthesis syn_edif_bit_format = "%u<%i>"
                // synthesis syn_edif_scalar_format = "%u"
                // synthesis syn_noclockbuf = 1
                // synthesis syn_hier = "hard"


  // Declare the port directions.

  input         FRAMEQ_N;
  input         TRDYQ_N;
  input         IRDYQ_N;
  input         STOPQ_N;
  input         DEVSELQ_N;
  input  [31:0] ADDR;
  inout  [31:0] ADIO;
  input         CFG_VLD;
  input         CFG_HIT;
  output        C_TERM;
  output        C_READY;
  input         ADDR_VLD;
  input   [7:0] BASE_HIT;
  output        S_TERM;
  output        S_READY;
  output        S_ABORT;
  input         S_WRDN;
  input         S_SRC_EN;
  input         S_DATA_VLD;
  input   [3:0] S_CBE;
  input  [15:0] PCI_CMD;
  output        REQUEST;
  output        REQUESTHOLD;
  output        COMPLETE;
  output        M_WRDN;
  output        M_READY;
  input         M_SRC_EN;
  input         M_DATA_VLD;
  output  [3:0] M_CBE;
  input         TIME_OUT;
  output        CFG_SELF;
  input         M_DATA;
  input         DR_BUS;
  input         I_IDLE;
  input         M_ADDR_N;
  input         IDLE;
  input         B_BUSY;
  input         S_DATA;
  input         BACKOFF;
  output        INTR_N;
  input         PERRQ_N;
  input         SERRQ_N;
  output        KEEPOUT;
  input  [39:0] CSR;
  output [31:0] SUB_DATA;
  input [255:0] CFG;
  input         RST;
  input         CLK;
  output        PING_DONE;
  input         PING_REQUEST32;

  parameter TDLY = 1;


  //******************************************************************//
  // This section contains the PCI interface decode.                  //
  //******************************************************************//

  reg           cfg_rd, bar0_rd, bar1_rd;
  reg           cfg_wr, bar0_wr, bar1_wr;
  wire          cfg_rd_cs, bar0_rd_cs, bar1_rd_cs;
  wire          cfg_wr_cs, bar0_wr_cs, bar1_wr_cs;

  always @(posedge CLK or posedge RST)
  begin : identify
    if (RST)
    begin
      cfg_rd  <= 1'b0;
      cfg_wr  <= 1'b0;
      bar0_rd <= 1'b0;
      bar0_wr <= 1'b0;
      bar1_rd <= 1'b0;
      bar1_wr <= 1'b0;
    end
    else
    begin
      if (CFG_HIT)
      begin
        cfg_rd <= !S_WRDN;
        cfg_wr <= S_WRDN;
      end
      else if (!S_DATA)
      begin
        cfg_rd <= 1'b0;
        cfg_wr <= 1'b0;
      end
      if (BASE_HIT[0])
      begin
        bar0_rd <= !S_WRDN;
        bar0_wr <= S_WRDN;
      end
      else if (!S_DATA)
      begin
        bar0_rd <= 1'b0;
        bar0_wr <= 1'b0;
      end
      if (BASE_HIT[1])
      begin
        bar1_rd <= !S_WRDN;
        bar1_wr <= S_WRDN;
      end
      else if (!S_DATA)
      begin
        bar1_rd <= 1'b0;
        bar1_wr <= 1'b0;
      end
    end
  end

  assign #TDLY cfg_rd_cs  = cfg_rd;
  assign #TDLY cfg_wr_cs  = cfg_wr;
  assign #TDLY bar0_rd_cs = bar0_rd;
  assign #TDLY bar0_wr_cs = bar0_wr;
  assign #TDLY bar1_rd_cs = bar1_rd;
  assign #TDLY bar1_wr_cs = bar1_wr;


  //******************************************************************//
  // This section contains the CFG32 implementation.                  //
  //******************************************************************//

  reg    [31:0] my_cfg_reg;
  wire          oe_cfg_reg;
  wire          en_cfg_reg;

  always @(posedge CLK or posedge RST)
  begin : write_my_cfg_reg
    if (RST) my_cfg_reg <= 32'h00000000;
    else if (S_DATA_VLD & cfg_wr_cs & en_cfg_reg)
    begin
      if (!S_CBE[0]) my_cfg_reg[ 7: 0] <= ADIO[ 7: 0];
      if (!S_CBE[1]) my_cfg_reg[15: 8] <= ADIO[15: 8];
      if (!S_CBE[2]) my_cfg_reg[23:16] <= ADIO[23:16];
      if (!S_CBE[3]) my_cfg_reg[31:24] <= ADIO[31:24];
    end
  end  

  assign #TDLY en_cfg_reg = ADDR[7] | ADDR[6];
  assign #TDLY oe_cfg_reg = en_cfg_reg & cfg_rd_cs & S_DATA & CFG[118];
  assign #TDLY ADIO = oe_cfg_reg ? my_cfg_reg : 32'bz;
  

  //******************************************************************//
  // This section contains the IO32 implementation.                   //
  //******************************************************************//

  reg    [31:0] my_io_reg;
  wire          oe_io_reg;

  always @(posedge CLK or posedge RST)
  begin : write_my_io_reg
    if (RST) my_io_reg <= 32'h10101010;
    else if (S_DATA_VLD & bar0_wr_cs)
    begin
      if (!S_CBE[0]) my_io_reg[ 7: 0] <= ADIO[ 7: 0];
      if (!S_CBE[1]) my_io_reg[15: 8] <= ADIO[15: 8];
      if (!S_CBE[2]) my_io_reg[23:16] <= ADIO[23:16];
      if (!S_CBE[3]) my_io_reg[31:24] <= ADIO[31:24];
    end
  end    

  assign #TDLY oe_io_reg = bar0_rd_cs & S_DATA;
  assign #TDLY ADIO = oe_io_reg ? my_io_reg : 32'bz;


  //******************************************************************//
  // This section contains the MEM32 implementation.                  //
  //******************************************************************//
 
  reg    [31:0] my_mem_reg;
  wire          oe_mem_reg;
 
  always @(posedge CLK or posedge RST)
  begin : write_my_mem_reg
    if (RST) my_mem_reg <= 32'h32323232;
    else if (S_DATA_VLD & bar1_wr_cs)
    begin
      if (!S_CBE[0]) my_mem_reg[ 7: 0] <= ADIO[ 7: 0];
      if (!S_CBE[1]) my_mem_reg[15: 8] <= ADIO[15: 8];
      if (!S_CBE[2]) my_mem_reg[23:16] <= ADIO[23:16];
      if (!S_CBE[3]) my_mem_reg[31:24] <= ADIO[31:24];
    end
  end
 
  assign #TDLY oe_mem_reg = bar1_rd_cs & S_DATA;
  assign #TDLY ADIO = oe_mem_reg ? my_mem_reg : 32'bz;


  //******************************************************************//
  // This section contains the initiator logic.                       //
  //******************************************************************//

  parameter     IDLE_S = 0;
  parameter     WRITE32_S = 1;
  parameter     READ32_S = 2;

  reg     [3:0] xfer_len;
  reg     [1:0] ping_state;
  reg     [1:0] nxt_ping_state;
  reg           xfer_load_delay;
  reg           mdata_delay;
  reg           feedback;
  reg           pre_done;
  reg           reg_preq32;
  wire          ns_done;
  wire          mdata_fell;
  wire          xfer_load;
  wire          start32;
  wire          dir;
  wire          cnt3, cnt2, cnt1;
  wire          fin3, fin2, fin1;
  wire          assert_complete;
  wire          hold_complete;
  wire          ping_done_o;
  wire          ping_req32_i;

  // Bus addresses are obtained from the MEM32 register.
  // Direction is from IO32[31] and burst length is IO32[3:0].
  // A general purpose register file is used for the source
  // or destination depending on the data transfer direction.

  always @(ping_state or start32 or mdata_fell or dir)
  begin : ping_fsm
    case (ping_state)

      // IDLE_S is the idle state.  If the state machine is
      // signaled to start, proceed to the next state.
      IDLE_S    : begin
                    if (start32 & dir) nxt_ping_state = WRITE32_S;
                    else if (start32 & !dir) nxt_ping_state = READ32_S;
                    else nxt_ping_state = IDLE_S;
                  end

      // WRITE32_S stays put until it sees a deassertion of
      // the M_DATA signal indicating that a transfer is over.
      // More elaborate FSMs may check error conditions at
      // the time mdata_fell is asserted.
      WRITE32_S : begin
                    if (mdata_fell) nxt_ping_state = IDLE_S;
                    else nxt_ping_state = WRITE32_S;
                  end

      // READ32_S stays put until it sees a deassertion of
      // the M_DATA signal indicating that a transfer is over.
      // More elaborate FSMs may check error conditions at
      // the time mdata_fell is asserted.
      READ32_S  : begin
                    if (mdata_fell) nxt_ping_state = IDLE_S;
                    else nxt_ping_state = READ32_S;
                  end

      // Include a default state just in case we have any accidents
      // with the state machine.
      default   : nxt_ping_state = IDLE_S;
    endcase
  end

  always @(posedge CLK or posedge RST)
  begin : ping_fsm_seq
    if (RST) ping_state <= IDLE_S;
    else ping_state <= nxt_ping_state;
  end

  // Need a delayed version of M_DATA and also
  // a delayed version of the transfer length
  // counter load signal.

  always @(posedge CLK or posedge RST)
  begin : misc_signals
    if (RST)
    begin
      mdata_delay <= 1'b0;
      xfer_load_delay <= 1'b0;
      pre_done <= 1'b0;
      reg_preq32 <= 1'b0;
    end
    else
    begin
      mdata_delay <= M_DATA;
      xfer_load_delay <= xfer_load;
      pre_done <= ns_done;
      reg_preq32 <= ping_req32_i;
    end
  end

  IBUF_PCI33_5 XPCI_PING_REQ32 (.O(ping_req32_i),.I(PING_REQUEST32));

  // This is the "set/reset" implementation for
  // the COMPLETE logic.  

  always @(posedge CLK or posedge RST)
  begin : hold_it
    if (RST) feedback <= 1'b0;
    else if (mdata_fell) feedback <= 1'b0;
    else if (assert_complete) feedback <= 1'b1;
  end

  // This is the transfer length counter.
  // Transfer lengths may be anywhere from
  // one to sixteen data phases.

  always @(posedge CLK or posedge RST)
  begin : transfer_counter
    if (RST) xfer_len <= 4'h0;
    else if (xfer_load) xfer_len <= my_io_reg[3:0];
    else if (M_DATA_VLD) xfer_len <= xfer_len - 4'h1;
  end

  // Decoded some things for the complete logic.

  assign #TDLY cnt3 = (xfer_len == 4'h3);
  assign #TDLY cnt2 = (xfer_len == 4'h2);
  assign #TDLY cnt1 = (xfer_len == 4'h1);
  assign #TDLY fin3 = cnt3 & M_DATA_VLD;
  assign #TDLY fin2 = cnt2 & mdata_delay;
  assign #TDLY fin1 = cnt1 & xfer_load_delay;

  // Generate some internal signals.

  assign #TDLY start32 = reg_preq32;
  assign #TDLY dir = my_io_reg[31];
  assign #TDLY mdata_fell = !M_DATA & mdata_delay;
  assign #TDLY xfer_load = start32 & (ping_state == IDLE_S);
  assign #TDLY assert_complete = fin1 | fin2 | fin3;
  assign #TDLY hold_complete = feedback;
  assign #TDLY ns_done = (ping_state != IDLE_S) & mdata_fell;


  // Drive outputs to the PCI interface.

  assign #TDLY REQUEST = (ping_state == IDLE_S) & start32;
  assign #TDLY COMPLETE = assert_complete | hold_complete;
  assign #TDLY M_WRDN = dir;
  assign #TDLY ADIO = M_ADDR_N ? 32'bz : my_mem_reg;
  assign #TDLY M_CBE = M_ADDR_N ? 4'h0 : {my_io_reg[7:5], dir};
  assign #TDLY ping_done_o = pre_done;

  OBUF_PCI33_5 XPCI_PING_DONE (.O(PING_DONE),.I(ping_done_o));

  // A simple 32-bit register for data transfer.

  reg    [31:0] my_init_reg;
  wire          oe_init_reg;
  wire          xlr, xlw;

  assign #TDLY xlr = (ping_state == READ32_S);
  assign #TDLY xlw = (ping_state == WRITE32_S);

  always @(posedge CLK or posedge RST)
  begin : write_my_init_reg
    if (RST) my_init_reg <= 32'h00000000;
    else if (M_DATA_VLD)
    begin
      if (xlr) my_init_reg[ 7: 0] <= ADIO[ 7: 0];
      if (xlr) my_init_reg[15: 8] <= ADIO[15: 8];
      if (xlr) my_init_reg[23:16] <= ADIO[23:16];
      if (xlr) my_init_reg[31:24] <= ADIO[31:24];
    end
  end
 
  assign #TDLY oe_init_reg = M_DATA & xlw;
  assign #TDLY ADIO = oe_init_reg ? my_init_reg : 32'bz;


  //******************************************************************//
  // This section contains unused signals.                            //
  //******************************************************************//

  assign #TDLY C_TERM = 1'b1;
  assign #TDLY C_READY = 1'b1;
  assign #TDLY KEEPOUT = 1'b0;
  assign #TDLY CFG_SELF = 1'b0;
  assign #TDLY REQUESTHOLD = 1'b0;
  assign #TDLY SUB_DATA = 32'h00000000;

  reg           S_TERM_reg;
  reg           S_READY_reg;
  reg           S_ABORT_reg;
  reg           M_READY_reg;
  reg           INTR_N_reg;
 
  always @(posedge CLK or posedge RST)
  begin : dont_optimize_please
    if (RST)
    begin
      INTR_N_reg <= 1'b0;
      S_TERM_reg <= 1'b1;
      S_READY_reg <= 1'b0;
      S_ABORT_reg <= 1'b1;
      M_READY_reg <= 1'b0;
    end
    else
    begin
      INTR_N_reg <= 1'b1;
      S_TERM_reg <= 1'b0;
      S_READY_reg <= 1'b1;
      S_ABORT_reg <= 1'b0;
      M_READY_reg <= 1'b1;
    end
  end

  assign #TDLY INTR_N = INTR_N_reg;
  assign #TDLY S_TERM = S_TERM_reg;
  assign #TDLY S_READY = S_READY_reg;
  assign #TDLY S_ABORT = S_ABORT_reg;
  assign #TDLY M_READY = M_READY_reg;


endmodule
