// mem_agent - sequencer + driver + monitor
class mem_agent extends uvm_agent;

  `uvm_component_utils(mem_agent)

  mem_agent_cfg cfg;

  mem_sequencer sqr;
  mem_driver    drv;
  mem_monitor   mon;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(mem_agent_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("NOCFG", "mem_agent_cfg not found")
    uvm_config_db#(mem_agent_cfg)::set(this, "*", "cfg", cfg);

    // monitor is always created, driver/sequencer only in active mode
    mon = mem_monitor::type_id::create("mon", this);

    if (cfg.is_active == UVM_ACTIVE) begin
      sqr = mem_sequencer::type_id::create("sqr", this);
      drv = mem_driver::type_id::create("drv", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    if (cfg.is_active == UVM_ACTIVE)
      drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction

endclass : mem_agent
