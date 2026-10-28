// ----------------------------------------------------------------------------
// minisoc_smoke_vseq  (T-SMOKE)
//
// Clocks + reset bring-up:
//   1) power-on reset
//   2) clocks check: clk = 2 GHz, mem_clk = configured period, sys_clk
//      stopped (PLL disabled after reset)
//   3) runtime reset with a random width (1..100 ns)
//   4) clocks check again
// DUT reset state (PLL unlocked, AES domain in reset, SPI config at reset
// values) is checked every reference cycle by the SVA in top_assertions.sv.
// ----------------------------------------------------------------------------
class minisoc_smoke_vseq extends minisoc_base_vseq;

  `uvm_object_utils(minisoc_smoke_vseq)

  rand int unsigned rst_width_ps;
  rand int unsigned run_ps;

  constraint c_width { rst_width_ps inside {[1_000 : 100_000]}; }
  constraint c_run   { run_ps inside {[50_000 : 200_000]}; }

  function new(string name = "minisoc_smoke_vseq");
    super.new(name);
  endfunction

  task body();
    `uvm_info("SMOKE", "1) Power-on reset", UVM_LOW)
    do_reset();

    wait_ps(run_ps);
    `uvm_info("SMOKE", "2) Clocks after power-on reset", UVM_LOW)
    check_clocks();

    `uvm_info("SMOKE", $sformatf("3) Runtime reset, width=%0dps", rst_width_ps), UVM_LOW)
    do_reset(rst_width_ps);

    wait_ps(run_ps);
    `uvm_info("SMOKE", "4) Clocks after runtime reset", UVM_LOW)
    check_clocks();
  endtask

  // CHK-CLK-00: measured clocks match the configuration; sys_clk is stopped
  // because the PLL is disabled after reset (REQ-PLL-01).
  protected task check_clocks();
    check_clock("clk",     p_sequencer.ref_clk_mon, p_sequencer.cfg.ref_clk_cfg.init_period_ps);
    check_clock("mem_clk", p_sequencer.mem_clk_mon, p_sequencer.cfg.mem_clk_cfg.init_period_ps);

    if (p_sequencer.sys_clk_mon.is_running())
      `uvm_error("CHK-CLK-00", $sformatf("sys_clk running (%0dps) with PLL disabled after reset",
                                         p_sequencer.sys_clk_mon.get_period() / 1ps))
    else
      `uvm_info("CHK-CLK-00", "sys_clk stopped (PLL disabled) - OK", UVM_LOW)
  endtask

  protected function void check_clock(string name, clk_monitor mon, int unsigned exp_ps);
    int unsigned got_ps = mon.get_period() / 1ps;
    if (!mon.is_running() || got_ps != exp_ps)
      `uvm_error("CHK-CLK-00", $sformatf("%s: running=%0b period=%0dps, expected %0dps",
                                         name, mon.is_running(), got_ps, exp_ps))
    else
      `uvm_info("CHK-CLK-00", $sformatf("%s period %0dps - OK", name, got_ps), UVM_LOW)
  endfunction

endclass : minisoc_smoke_vseq
