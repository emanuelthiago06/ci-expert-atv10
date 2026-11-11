class clk_sequencer extends uvm_sequencer #(clk_item);

  `uvm_component_utils(clk_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass : clk_sequencer
