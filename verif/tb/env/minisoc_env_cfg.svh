// ----------------------------------------------------------------------------
// minisoc_env_cfg
// ----------------------------------------------------------------------------
class minisoc_env_cfg extends uvm_object;

  `uvm_object_utils(minisoc_env_cfg)

  clk_agent_cfg ref_clk_cfg;   // clk, 2 GHz (REQ-CLK-01)
  clk_agent_cfg mem_clk_cfg;   // mem_clk, <= 200 MHz
  clk_agent_cfg sys_clk_cfg;   // dut.sys_clk probe, passive
  rst_agent_cfg rst_cfg;

  function new(string name = "minisoc_env_cfg");
    super.new(name);
    ref_clk_cfg = clk_agent_cfg::type_id::create("ref_clk_cfg");
    mem_clk_cfg = clk_agent_cfg::type_id::create("mem_clk_cfg");
    sys_clk_cfg = clk_agent_cfg::type_id::create("sys_clk_cfg");
    rst_cfg     = rst_agent_cfg::type_id::create("rst_cfg");

    ref_clk_cfg.init_period_ps = 500;      // 2 GHz
    mem_clk_cfg.init_period_ps = 10_000;   // 100 MHz
    sys_clk_cfg.is_active      = UVM_PASSIVE;
  endfunction

endclass : minisoc_env_cfg
