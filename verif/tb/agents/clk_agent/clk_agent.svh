// ----------------------------------------------------------------------------
// clk_agent
// ----------------------------------------------------------------------------
class clk_agent extends uvm_agent;

  `uvm_component_utils(clk_agent)

  clk_agent_cfg cfg;

  clk_sequencer sqr;
  clk_driver    drv;
  clk_monitor   mon;

  uvm_analysis_port #(clk_item) ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(clk_agent_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("NOCFG", "clk_agent_cfg not found")
    if (cfg.vif == null)
      `uvm_fatal("NOVIF", "clk_agent_cfg.vif is null")

    uvm_config_db#(clk_agent_cfg)::set(this, "*", "cfg", cfg);

    mon = clk_monitor::type_id::create("mon", this);

    if (cfg.is_active == UVM_ACTIVE) begin
      sqr = clk_sequencer::type_id::create("sqr", this);
      drv = clk_driver::type_id::create("drv", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    ap = mon.ap;
    if (cfg.is_active == UVM_ACTIVE)
      drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction

endclass : clk_agent
