`timescale 1ps/1ps

module tb_top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import minisoc_test_pkg::*;

  clk_if ref_clk_if ();
  clk_if mem_clk_if ();
  clk_if sys_clk_if ();
  rst_if rst_vif    ();
  spi_if spi_vif    ();
  mem_if mem_vif    ();

  // the memory interface works on mem_clk
  assign mem_vif.clk = mem_clk_if.clk;

  minisoc_top dut (
    .clk         (ref_clk_if.clk),
    .rst_n       (rst_vif.rst_n),

    .spi_sclk    (spi_vif.sclk),
    .spi_cs_n    (spi_vif.cs_n),
    .spi_mosi    (spi_vif.mosi),
    .spi_miso    (spi_vif.miso),

    .mem_clk     (mem_clk_if.clk),
    .mem_i_data  (mem_vif.wdata),
    .mem_i_wr_en (mem_vif.wr_en),
    .mem_i_addr  (mem_vif.addr),
    .mem_o_data  (mem_vif.rdata)
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
    uvm_config_db#(virtual mem_if)::set(null, "uvm_test_top", "mem_vif", mem_vif);
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
