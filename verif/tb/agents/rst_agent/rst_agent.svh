// ----------------------------------------------------------------------------
// rst_agent
// ----------------------------------------------------------------------------
class rst_agent extends uvm_agent;

  `uvm_component_utils(rst_agent)

  rst_agent_cfg cfg;

  rst_sequencer sqr;
  rst_driver    drv;
  rst_monitor   mon;

  uvm_analysis_port #(rst_item) ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(rst_agent_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("NOCFG", "rst_agent_cfg not found")
    if (cfg.vif == null)
      `uvm_fatal("NOVIF", "rst_agent_cfg.vif is null")

    uvm_config_db#(rst_agent_cfg)::set(this, "*", "cfg", cfg);

    mon = rst_monitor::type_id::create("mon", this);

    if (cfg.is_active == UVM_ACTIVE) begin
      sqr = rst_sequencer::type_id::create("sqr", this);
      drv = rst_driver::type_id::create("drv", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    ap = mon.ap;
    if (cfg.is_active == UVM_ACTIVE)
      drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction

endclass : rst_agent
