`timescale 1ps/1ps

// ----------------------------------------------------------------------------
// minisoc_top_sva - reset/clock assertions bound into minisoc_top (white-box)
//
// Oct/2026 scope (VPLAN A-RST-01..03, A-PLL-03). Failures are reported
// through UVM so they are counted by the test result.
// ----------------------------------------------------------------------------
module minisoc_top_sva (
  input logic       clk,
  input logic       rst_n,
  input logic       sys_clk,
  input logic       pll_locked,
  input logic       sys_rst_n,
  input logic       cfg_pll_enable,
  input logic [1:0] cfg_pll_div_sel,
  input logic       cfg_mem_sel_aes,
  input logic [8:0] cfg_num_blocks,
  input logic       cfg_start
);

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // A-RST-01: PLL unlocked while in reset (asynchronous reset).
  ast_rst_pll_unlocked: assert property (
    @(posedge clk) !rst_n |-> !pll_locked
  ) else `uvm_error("A-RST-01", "pll_locked high during reset")

  // A-RST-02: system (AES) domain held in reset while rst_n is low.
  ast_rst_sys_domain: assert property (
    @(posedge clk) !rst_n |-> !sys_rst_n
  ) else `uvm_error("A-RST-02", "sys_rst_n high during reset")

  // A-RST-03: SPI configuration takes its reset values.
  ast_rst_spi_cfg: assert property (
    @(posedge clk) !rst_n |=> (!cfg_pll_enable && !cfg_mem_sel_aes &&
                               cfg_pll_div_sel == 2'b11 && cfg_num_blocks == 9'd1 &&
                               !cfg_start)
  ) else `uvm_error("A-RST-03", $sformatf(
      "SPI cfg not at reset value: en=%0b sel=%0b div=%0d nblk=%0d start=%0b",
      cfg_pll_enable, cfg_mem_sel_aes, cfg_pll_div_sel, cfg_num_blocks, cfg_start))

  // A-PLL-03 (REQ-PLL-01): sys_clk only toggles while the PLL is locked.
  ast_sysclk_only_locked: assert property (
    @(posedge sys_clk) disable iff (!rst_n) pll_locked
  ) else `uvm_error("A-PLL-03", "sys_clk edge without PLL lock")

endmodule : minisoc_top_sva


// Bind into every minisoc_top instance.
bind minisoc_top minisoc_top_sva u_sva (
  .clk             (clk),
  .rst_n           (rst_n),
  .sys_clk         (sys_clk),
  .pll_locked      (pll_locked),
  .sys_rst_n       (sys_rst_n),
  .cfg_pll_enable  (spi_cfg_pll_enable),
  .cfg_pll_div_sel (spi_cfg_pll_div_sel),
  .cfg_mem_sel_aes (spi_cfg_mem_sel_aes),
  .cfg_num_blocks  (spi_cfg_num_blocks),
  .cfg_start       (spi_cfg_start)
);
