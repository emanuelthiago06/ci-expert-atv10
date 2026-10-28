// ----------------------------------------------------------------------------
// rst_agent_cfg
// ----------------------------------------------------------------------------
class rst_agent_cfg extends uvm_object;

  `uvm_object_utils(rst_agent_cfg)

  virtual rst_if vif;

  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new(string name = "rst_agent_cfg");
    super.new(name);
  endfunction

endclass : rst_agent_cfg
