// ----------------------------------------------------------------------------
// minisoc_vsequencer
//
// Virtual sequencer: handles to the agent sequencers and clock monitors plus
// the env config, so virtual sequences can coordinate interfaces and query
// the measured clocks.
// ----------------------------------------------------------------------------
class minisoc_vsequencer extends uvm_sequencer;

  `uvm_component_utils(minisoc_vsequencer)

  minisoc_env_cfg cfg;

  clk_sequencer ref_clk_sqr;
  clk_sequencer mem_clk_sqr;
  rst_sequencer rst_sqr;

  clk_monitor   ref_clk_mon;
  clk_monitor   mem_clk_mon;
  clk_monitor   sys_clk_mon;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass : minisoc_vsequencer
