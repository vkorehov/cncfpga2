`define MEMORY 1'b0
`define IO     1'b1

`define DISABLE  1'b0
`define ENABLE   1'b1

`define PREFETCH    1'b1
`define NOFETCH     1'b0
`define IO_PREFETCH 1'b1

`define TYPE00     2'b00
`define TYPE01     2'b01
`define TYPE10     2'b10
`define IO_TYPE    2'b11

// BAR sizes in bytes
`define SIZE2G     32'h8000_0000
`define SIZE1G     32'hc000_0000
`define SIZE512M   32'he000_0000
`define SIZE256M   32'hf000_0000
`define SIZE128M   32'hf800_0000
`define SIZE64M    32'hfc00_0000
`define SIZE32M    32'hfe00_0000
`define SIZE16M    32'hff00_0000
`define SIZE8M     32'hff80_0000
`define SIZE4M     32'hffc0_0000
`define SIZE2M     32'hffe0_0000
`define SIZE1M     32'hfff0_0000
`define SIZE512K   32'hfff8_0000
`define SIZE256K   32'hfffc_0000
`define SIZE128K   32'hfffe_0000
`define SIZE64K    32'hffff_0000
`define SIZE32K    32'hffff_8000
`define SIZE16K    32'hffff_c000
`define SIZE8K     32'hffff_e000
`define SIZE4K     32'hffff_f000
`define SIZE2K     32'hffff_f800
`define SIZE1K     32'hffff_fc00
`define SIZE512    32'hffff_fe00
`define SIZE256    32'hffff_ff00
`define SIZE128    32'hffff_ff80
`define SIZE64     32'hffff_ffc0
`define SIZE32     32'hffff_ffe0
`define SIZE16     32'hffff_fff0

module CFG ( CFG_VENDOR, CFG_CC_REVISION );
  // Declare the port directions.
  output [31:0]       CFG_VENDOR;
  output [31:0]       CFG_CC_REVISION;
  
  /*************************************************************/
  /*  Configure Device, Vendor ID, Class Code, and Revision ID */
  /*************************************************************/
  // Device ID and Vendor ID
  assign CFG_VENDOR[31:0] = 32'h0301_10ee ;
  // Class Code and Revision ID
  assign CFG_CC_REVISION[31:0] = 32'h0b40_0000 ;

  /*************************************************************/
  /*  Configure Base Address Registers                         */
  /*************************************************************/
  // BAR0
  //assign CFG[0]       = `ENABLE ;               // BAR enabled
  //assign CFG[32:1]    = `SIZE16 ;               // BAR size
  //assign CFG[33]      = `IO_PREFETCH ;          // Prefetchable
  //assign CFG[35:34]   = `IO_TYPE ;
  //assign CFG[36]      = `IO ;

endmodule
