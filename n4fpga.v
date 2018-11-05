//--------------------------------------------------------------------------------
// n4fpga.v - Top level module for the this project
// Author : Mohak Patel and Archit Tatwawadi

// Date        : Tue May 25 19:43:51 2018
//
// Description:
// ------------
// This module provides the top level for the final project hardware.
// The module assume that a PmodOLED is plugged into the JA 
// Servo PWM signal through JB port (First two pins)
// UARTLite Tx and Rx is connected to JC port(First two pins)
// expansion ports and that a PmodENC is plugged into the JD expansion 
// port (top row).
// PMODHB3 is plugged into the JB port.(top row)  
//////////////////////////////////////////////////////////////////////
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module n4fpga
   (RGB1_Blue_0,
    RGB1_Green_0,
    RGB1_Red_0,
    RGB2_Blue_0,
    RGB2_Green_0,
    RGB2_Red_0,
    an_0,
    btnC_0,
    btnD_0,
    btnL_0,
    btnR_0,
    btnU_0,
    ddr2_sdram_addr,
    ddr2_sdram_ba,
    ddr2_sdram_cas_n,
    ddr2_sdram_ck_n,
    ddr2_sdram_ck_p,
    ddr2_sdram_cke,
    ddr2_sdram_cs_n,
    ddr2_sdram_dm,
    ddr2_sdram_dq,
    ddr2_sdram_dqs_n,
    ddr2_sdram_dqs_p,
    ddr2_sdram_odt,
    ddr2_sdram_ras_n,
    ddr2_sdram_we_n,
    dp_0,
    led_0,
    reset,
    JA,
    JB_O,        
    JC,
	JD,
    seg_0,
    sw_0,
    sys_clock,
    usb_uart_rxd,
    usb_uart_txd);
  
  output RGB1_Blue_0;			// RGB1 LED (LD16) 
  output RGB1_Green_0;
  output RGB1_Red_0;
  output RGB2_Blue_0;			// RGB2 LED (LD17) 
  output RGB2_Green_0;
  output RGB2_Red_0;
  output [7:0]an_0;
  input btnC_0;					// Center Pushbutton
  input btnD_0;					// Down pushbutton
  input btnL_0;					// Left pushbutton
  input btnR_0;					// Right Pushbutton
  input btnU_0;					// Up Pushbutton
  output [12:0]ddr2_sdram_addr;
  output [2:0]ddr2_sdram_ba;
  output ddr2_sdram_cas_n;
  output [0:0]ddr2_sdram_ck_n;
  output [0:0]ddr2_sdram_ck_p;
  output [0:0]ddr2_sdram_cke;
  output [0:0]ddr2_sdram_cs_n;
  output [1:0]ddr2_sdram_dm;
  inout [15:0]ddr2_sdram_dq;
  inout [1:0]ddr2_sdram_dqs_n;
  inout [1:0]ddr2_sdram_dqs_p;
  output [0:0]ddr2_sdram_odt;
  output ddr2_sdram_ras_n;
  output ddr2_sdram_we_n;
  output dp_0;
  output [15:0]led_0;
  input reset;
  output [6:0]seg_0;
  input [15:0]sw_0;
  input sys_clock;
  inout [7:0] JA;                   // JA PmodOLED connector
  output [1:0] JB_O;                // JB [1:0] output for  Servo pwm
  inout [7:0] JC;                   // JC Pmod connector - TX and RX signals
  inout [7:0] JD;                   // JD Pmod connector - PmodENC signals
  input usb_uart_rxd;
  output usb_uart_txd;
  
  //wire for GPIO
  wire [31:0]GPIO_1_0_tri_i;
  wire [31:0]GPIO_1_1_tri_i;
  wire [31:0]GPIO_2_0_tri_o;
  wire [31:0]GPIO_2_1_tri_o;
  
  //wire for PMODOLEDrgb
  wire PmodOLEDrgb_out_0_pin10_i;
  wire PmodOLEDrgb_out_0_pin10_io;
  wire PmodOLEDrgb_out_0_pin10_o;
  wire PmodOLEDrgb_out_0_pin10_t;
  wire PmodOLEDrgb_out_0_pin1_i;
  wire PmodOLEDrgb_out_0_pin1_io;
  wire PmodOLEDrgb_out_0_pin1_o;
  wire PmodOLEDrgb_out_0_pin1_t;
  wire PmodOLEDrgb_out_0_pin2_i;
  wire PmodOLEDrgb_out_0_pin2_io;
  wire PmodOLEDrgb_out_0_pin2_o;
  wire PmodOLEDrgb_out_0_pin2_t;
  wire PmodOLEDrgb_out_0_pin3_i;
  wire PmodOLEDrgb_out_0_pin3_io;
  wire PmodOLEDrgb_out_0_pin3_o;
  wire PmodOLEDrgb_out_0_pin3_t;
  wire PmodOLEDrgb_out_0_pin4_i;
  wire PmodOLEDrgb_out_0_pin4_io;
  wire PmodOLEDrgb_out_0_pin4_o;
  wire PmodOLEDrgb_out_0_pin4_t;
  wire PmodOLEDrgb_out_0_pin7_i;
  wire PmodOLEDrgb_out_0_pin7_io;
  wire PmodOLEDrgb_out_0_pin7_o;
  wire PmodOLEDrgb_out_0_pin7_t;
  wire PmodOLEDrgb_out_0_pin8_i;
  wire PmodOLEDrgb_out_0_pin8_io;
  wire PmodOLEDrgb_out_0_pin8_o;
  wire PmodOLEDrgb_out_0_pin8_t;
  wire PmodOLEDrgb_out_0_pin9_i;
  wire PmodOLEDrgb_out_0_pin9_io;
  wire PmodOLEDrgb_out_0_pin9_o;
  wire PmodOLEDrgb_out_0_pin9_t;
  
  //wire for PMODENC
  wire Pmod_out_0_pin10_i;
  wire Pmod_out_0_pin10_io;
  wire Pmod_out_0_pin10_o;
  wire Pmod_out_0_pin10_t;
  wire Pmod_out_0_pin1_i;
  wire Pmod_out_0_pin1_io;
  wire Pmod_out_0_pin1_o;
  wire Pmod_out_0_pin1_t;
  wire Pmod_out_0_pin2_i;
  wire Pmod_out_0_pin2_io;
  wire Pmod_out_0_pin2_o;
  wire Pmod_out_0_pin2_t;
  wire Pmod_out_0_pin3_i;
  wire Pmod_out_0_pin3_io;
  wire Pmod_out_0_pin3_o;
  wire Pmod_out_0_pin3_t;
  wire Pmod_out_0_pin4_i;
  wire Pmod_out_0_pin4_io;
  wire Pmod_out_0_pin4_o;
  wire Pmod_out_0_pin4_t;
  wire Pmod_out_0_pin7_i;
  wire Pmod_out_0_pin7_io;
  wire Pmod_out_0_pin7_o;
  wire Pmod_out_0_pin7_t;
  wire Pmod_out_0_pin8_i;
  wire Pmod_out_0_pin8_io;
  wire Pmod_out_0_pin8_o;
  wire Pmod_out_0_pin8_t;
  wire Pmod_out_0_pin9_i;
  wire Pmod_out_0_pin9_io;
  wire Pmod_out_0_pin9_o;
  wire Pmod_out_0_pin9_t;
  
  //Wire for LED and buttons
  wire RGB1_Blue_0;
  wire RGB1_Green_0;
  wire RGB1_Red_0;
  wire RGB2_Blue_0;
  wire RGB2_Green_0;
  wire RGB2_Red_0;
  wire [7:0]an_0;
  wire btnC_0;
  wire btnD_0;
  wire btnL_0;
  wire btnR_0;
  wire btnU_0;
  
  //wire for DDR
  wire [12:0]ddr2_sdram_addr;
  wire [2:0]ddr2_sdram_ba;
  wire ddr2_sdram_cas_n;
  wire [0:0]ddr2_sdram_ck_n;
  wire [0:0]ddr2_sdram_ck_p;
  wire [0:0]ddr2_sdram_cke;
  wire [0:0]ddr2_sdram_cs_n;
  wire [1:0]ddr2_sdram_dm;
  wire [15:0]ddr2_sdram_dq;
  wire [1:0]ddr2_sdram_dqs_n;
  wire [1:0]ddr2_sdram_dqs_p;
  wire [0:0]ddr2_sdram_odt;
  wire ddr2_sdram_ras_n;
  wire ddr2_sdram_we_n;
  wire dp_0;
  wire [15:0]led_0;
  
  //Wire for PWM signal
  wire pwm0_0;
  wire pwm0_1;
  wire reset;
  wire [6:0]seg_0;
  
  //wire for SPI communication
  wire spi_rtl_io0_i;
  wire spi_rtl_io0_io;
  wire spi_rtl_io0_o;
  wire spi_rtl_io0_t;
  wire spi_rtl_io1_i;
  wire spi_rtl_io1_io;
  wire spi_rtl_io1_o;
  wire spi_rtl_io1_t;
  wire spi_rtl_sck_i;
  wire spi_rtl_sck_io;
  wire spi_rtl_sck_o;
  wire spi_rtl_sck_t;
  wire spi_rtl_spisel;
  wire [0:0]spi_rtl_ss_i_0;
  wire [0:0]spi_rtl_ss_io_0;
  wire [0:0]spi_rtl_ss_o_0;
  wire spi_rtl_ss_t;
  wire [15:0]sw_0;
  wire sys_clock;
  
  //wire for UART communication
  wire usb_uart_1_rxd;
  wire usb_uart_1_txd;
  wire usb_uart_rxd;
  wire usb_uart_txd;

// Pmod OLED connections 
        assign JA[0] = PmodOLEDrgb_out_0_pin1_io;
        assign JA[1] = PmodOLEDrgb_out_0_pin2_io;
        assign JA[2] = PmodOLEDrgb_out_0_pin3_io;
        assign JA[3] = PmodOLEDrgb_out_0_pin4_io;
        assign JA[4] = PmodOLEDrgb_out_0_pin7_io;
        assign JA[5] = PmodOLEDrgb_out_0_pin8_io;
        assign JA[6] = PmodOLEDrgb_out_0_pin9_io;
        assign JA[7] = PmodOLEDrgb_out_0_pin10_io;
        
        
        // JB Connector connections for PWM signal of servos
        assign JB_O[0]=pwm0_0;
        assign JB_O[1]=pwm0_1;
    
       
        // JC Connector pins for UART and SPI communication
        assign  usb_uart_1_rxd=JC[0]; 
       assign JC[1]=usb_uart_1_txd;
       assign spi_rtl_sck_i=JC[2];
       assign spi_rtl_spisel= JC[3];
       assign spi_rtl_io0_i=JC[4];
       assign JC[5]=spi_rtl_io1_o;
       
        // PmodENC signals
        // JD - top row
        // Pins are assigned such that turning the knob to the right
        // causes the rotary count to increment.
        assign  Pmod_out_0_pin1_io = JD[0];
        assign  Pmod_out_0_pin2_io = JD[1];
        assign  Pmod_out_0_pin3_io = JD[2];
        assign  Pmod_out_0_pin4_io = JD[3];



  IOBUF PmodOLEDrgb_out_0_pin10_iobuf
       (.I(PmodOLEDrgb_out_0_pin10_o),
        .IO(PmodOLEDrgb_out_0_pin10_io),
        .O(PmodOLEDrgb_out_0_pin10_i),
        .T(PmodOLEDrgb_out_0_pin10_t));
  IOBUF PmodOLEDrgb_out_0_pin1_iobuf
       (.I(PmodOLEDrgb_out_0_pin1_o),
        .IO(PmodOLEDrgb_out_0_pin1_io),
        .O(PmodOLEDrgb_out_0_pin1_i),
        .T(PmodOLEDrgb_out_0_pin1_t));
  IOBUF PmodOLEDrgb_out_0_pin2_iobuf
       (.I(PmodOLEDrgb_out_0_pin2_o),
        .IO(PmodOLEDrgb_out_0_pin2_io),
        .O(PmodOLEDrgb_out_0_pin2_i),
        .T(PmodOLEDrgb_out_0_pin2_t));
  IOBUF PmodOLEDrgb_out_0_pin3_iobuf
       (.I(PmodOLEDrgb_out_0_pin3_o),
        .IO(PmodOLEDrgb_out_0_pin3_io),
        .O(PmodOLEDrgb_out_0_pin3_i),
        .T(PmodOLEDrgb_out_0_pin3_t));
  IOBUF PmodOLEDrgb_out_0_pin4_iobuf
       (.I(PmodOLEDrgb_out_0_pin4_o),
        .IO(PmodOLEDrgb_out_0_pin4_io),
        .O(PmodOLEDrgb_out_0_pin4_i),
        .T(PmodOLEDrgb_out_0_pin4_t));
  IOBUF PmodOLEDrgb_out_0_pin7_iobuf
       (.I(PmodOLEDrgb_out_0_pin7_o),
        .IO(PmodOLEDrgb_out_0_pin7_io),
        .O(PmodOLEDrgb_out_0_pin7_i),
        .T(PmodOLEDrgb_out_0_pin7_t));
  IOBUF PmodOLEDrgb_out_0_pin8_iobuf
       (.I(PmodOLEDrgb_out_0_pin8_o),
        .IO(PmodOLEDrgb_out_0_pin8_io),
        .O(PmodOLEDrgb_out_0_pin8_i),
        .T(PmodOLEDrgb_out_0_pin8_t));
  IOBUF PmodOLEDrgb_out_0_pin9_iobuf
       (.I(PmodOLEDrgb_out_0_pin9_o),
        .IO(PmodOLEDrgb_out_0_pin9_io),
        .O(PmodOLEDrgb_out_0_pin9_i),
        .T(PmodOLEDrgb_out_0_pin9_t));
  IOBUF Pmod_out_0_pin10_iobuf
       (.I(Pmod_out_0_pin10_o),
        .IO(Pmod_out_0_pin10_io),
        .O(Pmod_out_0_pin10_i),
        .T(Pmod_out_0_pin10_t));
  IOBUF Pmod_out_0_pin1_iobuf
       (.I(Pmod_out_0_pin1_o),
        .IO(Pmod_out_0_pin1_io),
        .O(Pmod_out_0_pin1_i),
        .T(Pmod_out_0_pin1_t));
  IOBUF Pmod_out_0_pin2_iobuf
       (.I(Pmod_out_0_pin2_o),
        .IO(Pmod_out_0_pin2_io),
        .O(Pmod_out_0_pin2_i),
        .T(Pmod_out_0_pin2_t));
  IOBUF Pmod_out_0_pin3_iobuf
       (.I(Pmod_out_0_pin3_o),
        .IO(Pmod_out_0_pin3_io),
        .O(Pmod_out_0_pin3_i),
        .T(Pmod_out_0_pin3_t));
  IOBUF Pmod_out_0_pin4_iobuf
       (.I(Pmod_out_0_pin4_o),
        .IO(Pmod_out_0_pin4_io),
        .O(Pmod_out_0_pin4_i),
        .T(Pmod_out_0_pin4_t));
  IOBUF Pmod_out_0_pin7_iobuf
       (.I(Pmod_out_0_pin7_o),
        .IO(Pmod_out_0_pin7_io),
        .O(Pmod_out_0_pin7_i),
        .T(Pmod_out_0_pin7_t));
  IOBUF Pmod_out_0_pin8_iobuf
       (.I(Pmod_out_0_pin8_o),
        .IO(Pmod_out_0_pin8_io),
        .O(Pmod_out_0_pin8_i),
        .T(Pmod_out_0_pin8_t));
  IOBUF Pmod_out_0_pin9_iobuf
       (.I(Pmod_out_0_pin9_o),
        .IO(Pmod_out_0_pin9_io),
        .O(Pmod_out_0_pin9_i),
        .T(Pmod_out_0_pin9_t));
  n4fpga n4fpga_1_i
       (.GPIO_1_0_tri_i(GPIO_1_0_tri_i),
        .GPIO_1_1_tri_i(GPIO_1_1_tri_i),
        .GPIO_2_0_tri_o(GPIO_2_0_tri_o),
        .GPIO_2_1_tri_o(GPIO_2_1_tri_o),
        .PmodOLEDrgb_out_0_pin10_i(PmodOLEDrgb_out_0_pin10_i),
        .PmodOLEDrgb_out_0_pin10_o(PmodOLEDrgb_out_0_pin10_o),
        .PmodOLEDrgb_out_0_pin10_t(PmodOLEDrgb_out_0_pin10_t),
        .PmodOLEDrgb_out_0_pin1_i(PmodOLEDrgb_out_0_pin1_i),
        .PmodOLEDrgb_out_0_pin1_o(PmodOLEDrgb_out_0_pin1_o),
        .PmodOLEDrgb_out_0_pin1_t(PmodOLEDrgb_out_0_pin1_t),
        .PmodOLEDrgb_out_0_pin2_i(PmodOLEDrgb_out_0_pin2_i),
        .PmodOLEDrgb_out_0_pin2_o(PmodOLEDrgb_out_0_pin2_o),
        .PmodOLEDrgb_out_0_pin2_t(PmodOLEDrgb_out_0_pin2_t),
        .PmodOLEDrgb_out_0_pin3_i(PmodOLEDrgb_out_0_pin3_i),
        .PmodOLEDrgb_out_0_pin3_o(PmodOLEDrgb_out_0_pin3_o),
        .PmodOLEDrgb_out_0_pin3_t(PmodOLEDrgb_out_0_pin3_t),
        .PmodOLEDrgb_out_0_pin4_i(PmodOLEDrgb_out_0_pin4_i),
        .PmodOLEDrgb_out_0_pin4_o(PmodOLEDrgb_out_0_pin4_o),
        .PmodOLEDrgb_out_0_pin4_t(PmodOLEDrgb_out_0_pin4_t),
        .PmodOLEDrgb_out_0_pin7_i(PmodOLEDrgb_out_0_pin7_i),
        .PmodOLEDrgb_out_0_pin7_o(PmodOLEDrgb_out_0_pin7_o),
        .PmodOLEDrgb_out_0_pin7_t(PmodOLEDrgb_out_0_pin7_t),
        .PmodOLEDrgb_out_0_pin8_i(PmodOLEDrgb_out_0_pin8_i),
        .PmodOLEDrgb_out_0_pin8_o(PmodOLEDrgb_out_0_pin8_o),
        .PmodOLEDrgb_out_0_pin8_t(PmodOLEDrgb_out_0_pin8_t),
        .PmodOLEDrgb_out_0_pin9_i(PmodOLEDrgb_out_0_pin9_i),
        .PmodOLEDrgb_out_0_pin9_o(PmodOLEDrgb_out_0_pin9_o),
        .PmodOLEDrgb_out_0_pin9_t(PmodOLEDrgb_out_0_pin9_t),
        .Pmod_out_0_pin10_i(Pmod_out_0_pin10_i),
        .Pmod_out_0_pin10_o(Pmod_out_0_pin10_o),
        .Pmod_out_0_pin10_t(Pmod_out_0_pin10_t),
        .Pmod_out_0_pin1_i(Pmod_out_0_pin1_i),
        .Pmod_out_0_pin1_o(Pmod_out_0_pin1_o),
        .Pmod_out_0_pin1_t(Pmod_out_0_pin1_t),
        .Pmod_out_0_pin2_i(Pmod_out_0_pin2_i),
        .Pmod_out_0_pin2_o(Pmod_out_0_pin2_o),
        .Pmod_out_0_pin2_t(Pmod_out_0_pin2_t),
        .Pmod_out_0_pin3_i(Pmod_out_0_pin3_i),
        .Pmod_out_0_pin3_o(Pmod_out_0_pin3_o),
        .Pmod_out_0_pin3_t(Pmod_out_0_pin3_t),
        .Pmod_out_0_pin4_i(Pmod_out_0_pin4_i),
        .Pmod_out_0_pin4_o(Pmod_out_0_pin4_o),
        .Pmod_out_0_pin4_t(Pmod_out_0_pin4_t),
        .Pmod_out_0_pin7_i(Pmod_out_0_pin7_i),
        .Pmod_out_0_pin7_o(Pmod_out_0_pin7_o),
        .Pmod_out_0_pin7_t(Pmod_out_0_pin7_t),
        .Pmod_out_0_pin8_i(Pmod_out_0_pin8_i),
        .Pmod_out_0_pin8_o(Pmod_out_0_pin8_o),
        .Pmod_out_0_pin8_t(Pmod_out_0_pin8_t),
        .Pmod_out_0_pin9_i(Pmod_out_0_pin9_i),
        .Pmod_out_0_pin9_o(Pmod_out_0_pin9_o),
        .Pmod_out_0_pin9_t(Pmod_out_0_pin9_t),
        .RGB1_Blue_0(RGB1_Blue_0),
        .RGB1_Green_0(RGB1_Green_0),
        .RGB1_Red_0(RGB1_Red_0),
        .RGB2_Blue_0(RGB2_Blue_0),
        .RGB2_Green_0(RGB2_Green_0),
        .RGB2_Red_0(RGB2_Red_0),
        .an_0(an_0),
        .btnC_0(btnC_0),
        .btnD_0(btnD_0),
        .btnL_0(btnL_0),
        .btnR_0(btnR_0),
        .btnU_0(btnU_0),
        .ddr2_sdram_addr(ddr2_sdram_addr),
        .ddr2_sdram_ba(ddr2_sdram_ba),
        .ddr2_sdram_cas_n(ddr2_sdram_cas_n),
        .ddr2_sdram_ck_n(ddr2_sdram_ck_n),
        .ddr2_sdram_ck_p(ddr2_sdram_ck_p),
        .ddr2_sdram_cke(ddr2_sdram_cke),
        .ddr2_sdram_cs_n(ddr2_sdram_cs_n),
        .ddr2_sdram_dm(ddr2_sdram_dm),
        .ddr2_sdram_dq(ddr2_sdram_dq),
        .ddr2_sdram_dqs_n(ddr2_sdram_dqs_n),
        .ddr2_sdram_dqs_p(ddr2_sdram_dqs_p),
        .ddr2_sdram_odt(ddr2_sdram_odt),
        .ddr2_sdram_ras_n(ddr2_sdram_ras_n),
        .ddr2_sdram_we_n(ddr2_sdram_we_n),
        .dp_0(dp_0),
        .led_0(led_0),
        .pwm0_0(pwm0_0),
        .pwm0_1(pwm0_1),
        .reset(reset),
        .seg_0(seg_0),
        .spi_rtl_io0_i(spi_rtl_io0_i),
        .spi_rtl_io0_o(spi_rtl_io0_o),
        .spi_rtl_io0_t(spi_rtl_io0_t),
        .spi_rtl_io1_i(spi_rtl_io1_i),
        .spi_rtl_io1_o(spi_rtl_io1_o),
        .spi_rtl_io1_t(spi_rtl_io1_t),
        .spi_rtl_sck_i(spi_rtl_sck_i),
        .spi_rtl_sck_o(spi_rtl_sck_o),
        .spi_rtl_sck_t(spi_rtl_sck_t),
        .spi_rtl_spisel(spi_rtl_spisel),
        .spi_rtl_ss_i(spi_rtl_ss_i_0),
        .spi_rtl_ss_o(spi_rtl_ss_o_0),
        .spi_rtl_ss_t(spi_rtl_ss_t),
        .sw_0(sw_0),
        .sys_clock(sys_clock),
        .usb_uart_1_rxd(usb_uart_1_rxd),
        .usb_uart_1_txd(usb_uart_1_txd),
        .usb_uart_rxd(usb_uart_rxd),
        .usb_uart_txd(usb_uart_txd));
  IOBUF spi_rtl_io0_iobuf
       (.I(spi_rtl_io0_o),
        .IO(spi_rtl_io0_io),
        .O(spi_rtl_io0_i),
        .T(spi_rtl_io0_t));
  IOBUF spi_rtl_io1_iobuf
       (.I(spi_rtl_io1_o),
        .IO(spi_rtl_io1_io),
        .O(spi_rtl_io1_i),
        .T(spi_rtl_io1_t));
  IOBUF spi_rtl_sck_iobuf
       (.I(spi_rtl_sck_o),
        .IO(spi_rtl_sck_io),
        .O(spi_rtl_sck_i),
        .T(spi_rtl_sck_t));
 
endmodule
