// ----------------------------------------------------------------------------
// Reset sequences
// ----------------------------------------------------------------------------

// One reset pulse. Knobs can be pinned by the caller with randomize() with {}.
class rst_pulse_seq extends uvm_sequence #(rst_item);

  `uvm_object_utils(rst_pulse_seq)

  rand int unsigned pre_delay_ps;
  rand int unsigned width_ps;

  constraint c_default {
    soft pre_delay_ps inside {[1 : 2_000]};
    soft width_ps     inside {[5_000 : 20_000]};
  }

  function new(string name = "rst_pulse_seq");
    super.new(name);
  endfunction

  task body();
    req = rst_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with { pre_delay_ps == local::pre_delay_ps;
                                width_ps     == local::width_ps; })
      `uvm_fatal("RAND", "rst_item randomization failed")
    finish_item(req);
  endtask

endclass : rst_pulse_seq
