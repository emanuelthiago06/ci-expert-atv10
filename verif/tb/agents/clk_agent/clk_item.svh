// ----------------------------------------------------------------------------
// clk_item
//
// Driver side : request to start the clock with period_ps or to stop it.
// Monitor side: observed event (clock started / changed period / stopped).
// ----------------------------------------------------------------------------
class clk_item extends uvm_sequence_item;

  rand clk_op_e     op;
  rand int unsigned period_ps;

  // Filled by the monitor.
  time t_event;

  constraint c_period {
    period_ps inside {[2 : 1_000_000]};
    period_ps % 2 == 0;
  }

  `uvm_object_utils_begin(clk_item)
    `uvm_field_enum(clk_op_e, op, UVM_ALL_ON)
    `uvm_field_int(period_ps, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(t_event, UVM_ALL_ON | UVM_DEC)
  `uvm_object_utils_end

  function new(string name = "clk_item");
    super.new(name);
  endfunction

  function string convert2string();
    if (op == CLK_STOP)
      return $sformatf("CLK_STOP @%0t", t_event);
    return $sformatf("CLK_START period=%0dps (%.1f MHz) @%0t",
                     period_ps, 1.0e6 / period_ps, t_event);
  endfunction

endclass : clk_item
