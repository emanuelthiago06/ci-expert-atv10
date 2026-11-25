class mem_agent_cfg extends uvm_object;

  `uvm_object_utils(mem_agent_cfg)

  virtual mem_if vif;

  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new(string name = "mem_agent_cfg");
    super.new(name);
  endfunction

endclass : mem_agent_cfg
