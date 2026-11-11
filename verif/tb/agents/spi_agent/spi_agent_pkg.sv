`timescale 1ps/1ps

// ----------------------------------------------------------------------------
// spi_agent_pkg
//
// SPI master VIP (Mode 0, MSB-first, 40-bit frames). All times are expressed
// as integer picoseconds.
// ----------------------------------------------------------------------------
package spi_agent_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  localparam int unsigned SPI_FRAME_BITS = 40;

  // Register map (Block Guide section 6).
  typedef enum bit [5:0] {
    SPI_REG_KEY0           = 6'h00,
    SPI_REG_KEY1           = 6'h01,
    SPI_REG_KEY2           = 6'h02,
    SPI_REG_KEY3           = 6'h03,
    SPI_REG_IV0            = 6'h04,
    SPI_REG_IV1            = 6'h05,
    SPI_REG_IV2            = 6'h06,
    SPI_REG_IV3            = 6'h07,
    SPI_REG_COUNTER_HI     = 6'h08,
    SPI_REG_COUNTER_LO     = 6'h09,
    SPI_REG_NUM_BLOCKS     = 6'h0A,
    SPI_REG_AES_CONTROL    = 6'h0B,
    SPI_REG_AES_STATUS     = 6'h0C,
    SPI_REG_VERSION        = 6'h0D,
    SPI_REG_SYSTEM_CONTROL = 6'h0E,
    SPI_REG_SYSTEM_STATUS  = 6'h0F,
    SPI_REG_NOP            = 6'h3F
  } spi_reg_e;

  `include "spi_agent_cfg.svh"
  `include "spi_item.svh"

  typedef uvm_sequencer #(spi_item) spi_sequencer;

  `include "spi_driver.svh"
  `include "spi_monitor.svh"
  `include "spi_agent.svh"
  `include "spi_seq_lib.svh"

endpackage : spi_agent_pkg
