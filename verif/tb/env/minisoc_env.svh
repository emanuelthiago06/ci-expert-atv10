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
  spi_agent spi_agt;
  mem_agent mem_agt;

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
    uvm_config_db#(spi_agent_cfg)::set(this, "spi_agt",     "cfg", cfg.spi_cfg);
    uvm_config_db#(mem_agent_cfg)::set(this, "mem_agt",     "cfg", cfg.mem_cfg);

    ref_clk_agt = clk_agent::type_id::create("ref_clk_agt", this);
    mem_clk_agt = clk_agent::type_id::create("mem_clk_agt", this);
    sys_clk_agt = clk_agent::type_id::create("sys_clk_agt", this);
    rst_agt     = rst_agent::type_id::create("rst_agt", this);
    spi_agt     = spi_agent::type_id::create("spi_agt", this);
    mem_agt     = mem_agent::type_id::create("mem_agt", this);
  endfunction

endclass : minisoc_env
