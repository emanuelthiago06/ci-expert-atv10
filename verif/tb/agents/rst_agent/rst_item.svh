// ----------------------------------------------------------------------------
// rst_item
//
// Driver side : one reset pulse = wait pre_delay_ps, assert rst_n=0 for
//               width_ps, release.
// Monitor side: one edge event (RST_ASSERT / RST_DEASSERT); width_ps holds the
//               measured pulse width on RST_DEASSERT.
// ----------------------------------------------------------------------------
class rst_item extends uvm_sequence_item;

  rand int unsigned pre_delay_ps;
  rand int unsigned width_ps;

  // Filled by the monitor.
  rst_evt_e evt;
  time      t_event;

  // The reset is asynchronous, so the width is not tied to the 2 GHz period.
  // Lower bound keeps the pulse wider than 2 reference cycles so the
  // synchronous-reset SPI register bank also sees it.
  constraint c_width {
    width_ps inside {[1_000 : 100_000]};
  }

  constraint c_delay {
    pre_delay_ps inside {[1 : 50_000]};
  }

  `uvm_object_utils_begin(rst_item)
    `uvm_field_int(pre_delay_ps, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(width_ps, UVM_ALL_ON | UVM_DEC)
    `uvm_field_enum(rst_evt_e, evt, UVM_ALL_ON)
    `uvm_field_int(t_event, UVM_ALL_ON | UVM_DEC)
  `uvm_object_utils_end

  function new(string name = "rst_item");
    super.new(name);
  endfunction

  function string convert2string();
    if (evt == RST_ASSERT)
      return $sformatf("RST_ASSERT @%0t", t_event);
    return $sformatf("RST_DEASSERT @%0t (width=%0dps)", t_event, width_ps);
  endfunction

endclass : rst_item
