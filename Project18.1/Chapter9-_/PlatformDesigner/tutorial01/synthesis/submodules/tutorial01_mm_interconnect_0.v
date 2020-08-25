// tutorial01_mm_interconnect_0.v

// This file was auto-generated from altera_mm_interconnect_hw.tcl.  If you edit it your changes
// will probably be lost.
// 
// Generated using ACDS version 18.1 625

`timescale 1 ps / 1 ps
module tutorial01_mm_interconnect_0 (
		input  wire        PLL_c0_clk,                                         //                                       PLL_c0.clk
		input  wire        WS2812_RAM_INT_0_reset_reset_bridge_in_reset_reset, // WS2812_RAM_INT_0_reset_reset_bridge_in_reset.reset
		input  wire [16:0] WS2812_RAM_INT_0_avalon_master_address,             //               WS2812_RAM_INT_0_avalon_master.address
		input  wire [3:0]  WS2812_RAM_INT_0_avalon_master_byteenable,          //                                             .byteenable
		input  wire        WS2812_RAM_INT_0_avalon_master_read,                //                                             .read
		output wire [31:0] WS2812_RAM_INT_0_avalon_master_readdata,            //                                             .readdata
		input  wire        WS2812_RAM_INT_0_avalon_master_write,               //                                             .write
		input  wire [31:0] WS2812_RAM_INT_0_avalon_master_writedata,           //                                             .writedata
		output wire [4:0]  RAM_WS2812_s2_address,                              //                                RAM_WS2812_s2.address
		output wire        RAM_WS2812_s2_write,                                //                                             .write
		input  wire [31:0] RAM_WS2812_s2_readdata,                             //                                             .readdata
		output wire [31:0] RAM_WS2812_s2_writedata,                            //                                             .writedata
		output wire [3:0]  RAM_WS2812_s2_byteenable,                           //                                             .byteenable
		output wire        RAM_WS2812_s2_chipselect,                           //                                             .chipselect
		output wire        RAM_WS2812_s2_clken                                 //                                             .clken
	);

	wire         ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_waitrequest;   // RAM_WS2812_s2_translator:uav_waitrequest -> WS2812_RAM_INT_0_avalon_master_translator:uav_waitrequest
	wire  [31:0] ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_readdata;      // RAM_WS2812_s2_translator:uav_readdata -> WS2812_RAM_INT_0_avalon_master_translator:uav_readdata
	wire         ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_debugaccess;   // WS2812_RAM_INT_0_avalon_master_translator:uav_debugaccess -> RAM_WS2812_s2_translator:uav_debugaccess
	wire  [18:0] ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_address;       // WS2812_RAM_INT_0_avalon_master_translator:uav_address -> RAM_WS2812_s2_translator:uav_address
	wire         ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_read;          // WS2812_RAM_INT_0_avalon_master_translator:uav_read -> RAM_WS2812_s2_translator:uav_read
	wire   [3:0] ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_byteenable;    // WS2812_RAM_INT_0_avalon_master_translator:uav_byteenable -> RAM_WS2812_s2_translator:uav_byteenable
	wire         ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_readdatavalid; // RAM_WS2812_s2_translator:uav_readdatavalid -> WS2812_RAM_INT_0_avalon_master_translator:uav_readdatavalid
	wire         ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_lock;          // WS2812_RAM_INT_0_avalon_master_translator:uav_lock -> RAM_WS2812_s2_translator:uav_lock
	wire         ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_write;         // WS2812_RAM_INT_0_avalon_master_translator:uav_write -> RAM_WS2812_s2_translator:uav_write
	wire  [31:0] ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_writedata;     // WS2812_RAM_INT_0_avalon_master_translator:uav_writedata -> RAM_WS2812_s2_translator:uav_writedata
	wire   [2:0] ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_burstcount;    // WS2812_RAM_INT_0_avalon_master_translator:uav_burstcount -> RAM_WS2812_s2_translator:uav_burstcount

	altera_merlin_master_translator #(
		.AV_ADDRESS_W                (17),
		.AV_DATA_W                   (32),
		.AV_BURSTCOUNT_W             (1),
		.AV_BYTEENABLE_W             (4),
		.UAV_ADDRESS_W               (19),
		.UAV_BURSTCOUNT_W            (3),
		.USE_READ                    (1),
		.USE_WRITE                   (1),
		.USE_BEGINBURSTTRANSFER      (0),
		.USE_BEGINTRANSFER           (0),
		.USE_CHIPSELECT              (0),
		.USE_BURSTCOUNT              (0),
		.USE_READDATAVALID           (0),
		.USE_WAITREQUEST             (0),
		.USE_READRESPONSE            (0),
		.USE_WRITERESPONSE           (0),
		.AV_SYMBOLS_PER_WORD         (4),
		.AV_ADDRESS_SYMBOLS          (0),
		.AV_BURSTCOUNT_SYMBOLS       (0),
		.AV_CONSTANT_BURST_BEHAVIOR  (0),
		.UAV_CONSTANT_BURST_BEHAVIOR (0),
		.AV_LINEWRAPBURSTS           (0),
		.AV_REGISTERINCOMINGSIGNALS  (0)
	) ws2812_ram_int_0_avalon_master_translator (
		.clk                    (PLL_c0_clk),                                                                        //                       clk.clk
		.reset                  (WS2812_RAM_INT_0_reset_reset_bridge_in_reset_reset),                                //                     reset.reset
		.uav_address            (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_address),       // avalon_universal_master_0.address
		.uav_burstcount         (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_burstcount),    //                          .burstcount
		.uav_read               (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_read),          //                          .read
		.uav_write              (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_write),         //                          .write
		.uav_waitrequest        (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_waitrequest),   //                          .waitrequest
		.uav_readdatavalid      (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_readdatavalid), //                          .readdatavalid
		.uav_byteenable         (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_byteenable),    //                          .byteenable
		.uav_readdata           (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_readdata),      //                          .readdata
		.uav_writedata          (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_writedata),     //                          .writedata
		.uav_lock               (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_lock),          //                          .lock
		.uav_debugaccess        (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_debugaccess),   //                          .debugaccess
		.av_address             (WS2812_RAM_INT_0_avalon_master_address),                                            //      avalon_anti_master_0.address
		.av_byteenable          (WS2812_RAM_INT_0_avalon_master_byteenable),                                         //                          .byteenable
		.av_read                (WS2812_RAM_INT_0_avalon_master_read),                                               //                          .read
		.av_readdata            (WS2812_RAM_INT_0_avalon_master_readdata),                                           //                          .readdata
		.av_write               (WS2812_RAM_INT_0_avalon_master_write),                                              //                          .write
		.av_writedata           (WS2812_RAM_INT_0_avalon_master_writedata),                                          //                          .writedata
		.av_waitrequest         (),                                                                                  //               (terminated)
		.av_burstcount          (1'b1),                                                                              //               (terminated)
		.av_beginbursttransfer  (1'b0),                                                                              //               (terminated)
		.av_begintransfer       (1'b0),                                                                              //               (terminated)
		.av_chipselect          (1'b0),                                                                              //               (terminated)
		.av_readdatavalid       (),                                                                                  //               (terminated)
		.av_lock                (1'b0),                                                                              //               (terminated)
		.av_debugaccess         (1'b0),                                                                              //               (terminated)
		.uav_clken              (),                                                                                  //               (terminated)
		.av_clken               (1'b1),                                                                              //               (terminated)
		.uav_response           (2'b00),                                                                             //               (terminated)
		.av_response            (),                                                                                  //               (terminated)
		.uav_writeresponsevalid (1'b0),                                                                              //               (terminated)
		.av_writeresponsevalid  ()                                                                                   //               (terminated)
	);

	altera_merlin_slave_translator #(
		.AV_ADDRESS_W                   (5),
		.AV_DATA_W                      (32),
		.UAV_DATA_W                     (32),
		.AV_BURSTCOUNT_W                (1),
		.AV_BYTEENABLE_W                (4),
		.UAV_BYTEENABLE_W               (4),
		.UAV_ADDRESS_W                  (19),
		.UAV_BURSTCOUNT_W               (3),
		.AV_READLATENCY                 (1),
		.USE_READDATAVALID              (0),
		.USE_WAITREQUEST                (0),
		.USE_UAV_CLKEN                  (0),
		.USE_READRESPONSE               (0),
		.USE_WRITERESPONSE              (0),
		.AV_SYMBOLS_PER_WORD            (4),
		.AV_ADDRESS_SYMBOLS             (0),
		.AV_BURSTCOUNT_SYMBOLS          (0),
		.AV_CONSTANT_BURST_BEHAVIOR     (0),
		.UAV_CONSTANT_BURST_BEHAVIOR    (0),
		.AV_REQUIRE_UNALIGNED_ADDRESSES (0),
		.CHIPSELECT_THROUGH_READLATENCY (0),
		.AV_READ_WAIT_CYCLES            (0),
		.AV_WRITE_WAIT_CYCLES           (0),
		.AV_SETUP_WAIT_CYCLES           (0),
		.AV_DATA_HOLD_CYCLES            (0)
	) ram_ws2812_s2_translator (
		.clk                    (PLL_c0_clk),                                                                        //                      clk.clk
		.reset                  (WS2812_RAM_INT_0_reset_reset_bridge_in_reset_reset),                                //                    reset.reset
		.uav_address            (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_address),       // avalon_universal_slave_0.address
		.uav_burstcount         (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_burstcount),    //                         .burstcount
		.uav_read               (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_read),          //                         .read
		.uav_write              (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_write),         //                         .write
		.uav_waitrequest        (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_waitrequest),   //                         .waitrequest
		.uav_readdatavalid      (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_readdatavalid), //                         .readdatavalid
		.uav_byteenable         (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_byteenable),    //                         .byteenable
		.uav_readdata           (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_readdata),      //                         .readdata
		.uav_writedata          (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_writedata),     //                         .writedata
		.uav_lock               (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_lock),          //                         .lock
		.uav_debugaccess        (ws2812_ram_int_0_avalon_master_translator_avalon_universal_master_0_debugaccess),   //                         .debugaccess
		.av_address             (RAM_WS2812_s2_address),                                                             //      avalon_anti_slave_0.address
		.av_write               (RAM_WS2812_s2_write),                                                               //                         .write
		.av_readdata            (RAM_WS2812_s2_readdata),                                                            //                         .readdata
		.av_writedata           (RAM_WS2812_s2_writedata),                                                           //                         .writedata
		.av_byteenable          (RAM_WS2812_s2_byteenable),                                                          //                         .byteenable
		.av_chipselect          (RAM_WS2812_s2_chipselect),                                                          //                         .chipselect
		.av_clken               (RAM_WS2812_s2_clken),                                                               //                         .clken
		.av_read                (),                                                                                  //              (terminated)
		.av_begintransfer       (),                                                                                  //              (terminated)
		.av_beginbursttransfer  (),                                                                                  //              (terminated)
		.av_burstcount          (),                                                                                  //              (terminated)
		.av_readdatavalid       (1'b0),                                                                              //              (terminated)
		.av_waitrequest         (1'b0),                                                                              //              (terminated)
		.av_writebyteenable     (),                                                                                  //              (terminated)
		.av_lock                (),                                                                                  //              (terminated)
		.uav_clken              (1'b0),                                                                              //              (terminated)
		.av_debugaccess         (),                                                                                  //              (terminated)
		.av_outputenable        (),                                                                                  //              (terminated)
		.uav_response           (),                                                                                  //              (terminated)
		.av_response            (2'b00),                                                                             //              (terminated)
		.uav_writeresponsevalid (),                                                                                  //              (terminated)
		.av_writeresponsevalid  (1'b0)                                                                               //              (terminated)
	);

endmodule