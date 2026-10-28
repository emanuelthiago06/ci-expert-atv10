// ----------------------------------------------------------------------------
// minisoc_env
// ----------------------------------------------------------------------------
class minisoc_env extends uvm_env;

  `uvm_component_utils(minisoc_env)

  minisoc_env_cfg cfg;

  clk_agent ref_clk_agt;
  clk_agent mem_clk_agt;
  clk_agent sys_clk_agt;
  rst_agent rst_agt;

  minisoc_vsequencer vsqr;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(minisoc_env_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("NOCFG", "minisoc_env_cfg not found")

    uvm_config_db#(clk_agent_cfg)::set(this, "ref_clk_agt", "cfg", cfg.ref_clk_cfg);
    uvm_config_db#(clk_agent_cfg)::set(this, "mem_clk_agt", "cfg", cfg.mem_clk_cfg);
    uvm_config_db#(clk_agent_cfg)::set(this, "sys_clk_agt", "cfg", cfg.sys_clk_cfg);
    uvm_config_db#(rst_agent_cfg)::set(this, "rst_agt",     "cfg", cfg.rst_cfg);

    ref_clk_agt = clk_agent::type_id::create("ref_clk_agt", this);
    mem_clk_agt = clk_agent::type_id::create("mem_clk_agt", this);
    sys_clk_agt = clk_agent::type_id::create("sys_clk_agt", this);
    rst_agt     = rst_agent::type_id::create("rst_agt", this);

    vsqr = minisoc_vsequencer::type_id::create("vsqr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    vsqr.cfg         = cfg;
    vsqr.ref_clk_sqr = ref_clk_agt.sqr;
    vsqr.mem_clk_sqr = mem_clk_agt.sqr;
    vsqr.rst_sqr     = rst_agt.sqr;
    vsqr.ref_clk_mon = ref_clk_agt.mon;
    vsqr.mem_clk_mon = mem_clk_agt.mon;
    vsqr.sys_clk_mon = sys_clk_agt.mon;
  endfunction

endclass : minisoc_env
