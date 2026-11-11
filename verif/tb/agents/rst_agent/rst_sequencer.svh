class rst_sequencer extends uvm_sequencer #(rst_item);

  `uvm_component_utils(rst_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass : rst_sequencer
