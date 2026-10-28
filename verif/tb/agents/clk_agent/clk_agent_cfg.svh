// ----------------------------------------------------------------------------
// clk_agent_cfg
// ----------------------------------------------------------------------------
class clk_agent_cfg extends uvm_object;

  `uvm_object_utils(clk_agent_cfg)

  virtual clk_if vif;

  uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Driver: when auto_start=1 the clock starts at time 0 with init_period_ps,
  // so the DUT has a clock before any sequence runs.
  bit          auto_start     = 1'b1;
  int unsigned init_period_ps = 500;

  // Monitor: a new period is reported only after it has been observed on
  // stable_edges consecutive cycles; the clock is declared stopped when no
  // rising edge is seen for stop_timeout_ps.
  int unsigned stable_edges    = 3;
  int unsigned stop_timeout_ps = 20_000;

  function new(string name = "clk_agent_cfg");
    super.new(name);
  endfunction

endclass : clk_agent_cfg
