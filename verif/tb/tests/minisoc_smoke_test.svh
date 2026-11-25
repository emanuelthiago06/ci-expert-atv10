// minisoc_smoke_test (T-SMOKE)
//   1) reset, check the clocks
//   2) reset again during operation, check the clocks again
// The DUT reset state is checked by the SVA in top_assertions.sv.
class minisoc_smoke_test extends minisoc_base_test;

  `uvm_component_utils(minisoc_smoke_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("SMOKE", "1) Power-on reset", UVM_LOW)
    reset_dut(10_000);
    #100ns;
    check_clocks();

    `uvm_info("SMOKE", "2) Second reset", UVM_LOW)
    reset_dut(2_000);
    #100ns;
    check_clocks();

    phase.drop_objection(this);
  endtask

  // CHK-CLK-00: clk = 2 GHz, mem_clk = 100 MHz, sys_clk stopped (PLL off after reset)
  function void check_clocks();
    int unsigned clk_ps;
    int unsigned mem_clk_ps;

    clk_ps     = env.ref_clk_agt.mon.get_period() / 1ps;
    mem_clk_ps = env.mem_clk_agt.mon.get_period() / 1ps;

    if (clk_ps == 500)
      `uvm_info("CHK-CLK-00", "clk period 500ps - OK", UVM_LOW)
    else
      `uvm_error("CHK-CLK-00", $sformatf("clk period %0dps, expected 500ps", clk_ps))

    if (mem_clk_ps == 10_000)
      `uvm_info("CHK-CLK-00", "mem_clk period 10000ps - OK", UVM_LOW)
    else
      `uvm_error("CHK-CLK-00", $sformatf("mem_clk period %0dps, expected 10000ps", mem_clk_ps))

    if (env.sys_clk_agt.mon.is_running())
      `uvm_error("CHK-CLK-00", "sys_clk is running but the PLL is disabled")
    else
      `uvm_info("CHK-CLK-00", "sys_clk stopped - OK", UVM_LOW)
  endfunction

endclass : minisoc_smoke_test
