`timescale 1ps/1ps

// ----------------------------------------------------------------------------
// tb_top - MiniSoC AES UVM testbench top (Oct/2026 baseline: clock + reset)
//
//   ref_clk_if  -> clk          (clk_agent, ACTIVE, 2 GHz)
//   rst_if      -> rst_n        (rst_agent, ACTIVE)
//   mem_clk_if  -> mem_clk      (clk_agent, ACTIVE)
//   sys_clk_if  <- dut.sys_clk  (clk_agent, PASSIVE probe of the PLL output)
//   spi_vif     <-> SPI pins    (spi_agent, ACTIVE master)
//
// MEMORY DATA pins are tied to their idle values until the MEMORY DATA agent
// is integrated (Nov/2026 milestone).
//
// Waves: +define+WAVES_FSDB (Verdi) or +define+WAVES_VPD at compile time.
// ----------------------------------------------------------------------------
module tb_top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import minisoc_test_pkg::*;

  clk_if ref_clk_if ();
  clk_if mem_clk_if ();
  clk_if sys_clk_if ();
  rst_if rst_vif    ();
  spi_if spi_vif    ();

  // MEMORY DATA tie-off.
  logic [31:0] mem_o_data;

  minisoc_top dut (
    .clk         (ref_clk_if.clk),
    .rst_n       (rst_vif.rst_n),

    .spi_sclk    (spi_vif.sclk),
    .spi_cs_n    (spi_vif.cs_n),
    .spi_mosi    (spi_vif.mosi),
    .spi_miso    (spi_vif.miso),

    .mem_clk     (mem_clk_if.clk),
    .mem_i_data  (32'b0),
    .mem_i_wr_en (1'b0),
    .mem_i_addr  (10'b0),
    .mem_o_data  (mem_o_data)
  );

  // White-box probe: PLL-generated system clock.
  assign sys_clk_if.clk = dut.sys_clk;

  // SVA checker: bound into minisoc_top in top_assertions.sv.

  initial begin
    uvm_config_db#(virtual clk_if)::set(null, "uvm_test_top", "ref_clk_vif", ref_clk_if);
    uvm_config_db#(virtual clk_if)::set(null, "uvm_test_top", "mem_clk_vif", mem_clk_if);
    uvm_config_db#(virtual clk_if)::set(null, "uvm_test_top", "sys_clk_vif", sys_clk_if);
    uvm_config_db#(virtual rst_if)::set(null, "uvm_test_top", "rst_vif", rst_vif);
    uvm_config_db#(virtual spi_if)::set(null, "uvm_test_top", "spi_vif", spi_vif);
    run_test();
  end

`ifdef WAVES_FSDB
  initial begin
    $fsdbDumpfile("waves.fsdb");
    $fsdbDumpvars(0, tb_top, "+all");
  end
`elsif WAVES_VPD
  initial begin
    $vcdplusfile("waves.vpd");
    $vcdpluson(0, tb_top);
  end
`endif

endmodule : tb_top
