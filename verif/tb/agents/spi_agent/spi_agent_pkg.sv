`timescale 1ps/1ps

// spi_agent_pkg - SPI VIP (master)
package spi_agent_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // register map (from minisoc_spi.sv)
  localparam bit [5:0] SPI_REG_KEY0           = 6'h00;
  localparam bit [5:0] SPI_REG_KEY1           = 6'h01;
  localparam bit [5:0] SPI_REG_KEY2           = 6'h02;
  localparam bit [5:0] SPI_REG_KEY3           = 6'h03;
  localparam bit [5:0] SPI_REG_IV0            = 6'h04;
  localparam bit [5:0] SPI_REG_IV1            = 6'h05;
  localparam bit [5:0] SPI_REG_IV2            = 6'h06;
  localparam bit [5:0] SPI_REG_IV3            = 6'h07;
  localparam bit [5:0] SPI_REG_COUNTER_HI     = 6'h08;
  localparam bit [5:0] SPI_REG_COUNTER_LO     = 6'h09;
  localparam bit [5:0] SPI_REG_NUM_BLOCKS     = 6'h0A;
  localparam bit [5:0] SPI_REG_AES_CONTROL    = 6'h0B;
  localparam bit [5:0] SPI_REG_AES_STATUS     = 6'h0C;
  localparam bit [5:0] SPI_REG_VERSION        = 6'h0D;
  localparam bit [5:0] SPI_REG_SYSTEM_CONTROL = 6'h0E;
  localparam bit [5:0] SPI_REG_SYSTEM_STATUS  = 6'h0F;
  localparam bit [5:0] SPI_REG_NOP            = 6'h3F;

  `include "spi_agent_cfg.svh"
  `include "spi_item.svh"

  `include "spi_sequencer.svh"

  `include "spi_driver.svh"
  `include "spi_monitor.svh"
  `include "spi_agent.svh"
  `include "spi_seq_lib.svh"

endpackage : spi_agent_pkg
