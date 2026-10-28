// ----------------------------------------------------------------------------
// minisoc_base_vseq
//
// Helpers shared by all virtual sequences.
// ----------------------------------------------------------------------------
class minisoc_base_vseq extends uvm_sequence;

  `uvm_object_utils(minisoc_base_vseq)
  `uvm_declare_p_sequencer(minisoc_vsequencer)

  function new(string name = "minisoc_base_vseq");
    super.new(name);
  endfunction

  // One reset pulse. 0 = randomized by rst_pulse_seq.
  task do_reset(int unsigned width_ps = 0, int unsigned pre_delay_ps = 0);
    rst_pulse_seq s = rst_pulse_seq::type_id::create("rst_s");
    if (!s.randomize() with {
          if (local::width_ps     != 0) width_ps     == local::width_ps;
          if (local::pre_delay_ps != 0) pre_delay_ps == local::pre_delay_ps; })
      `uvm_fatal("RAND", "rst_pulse_seq randomization failed")
    s.start(p_sequencer.rst_sqr, this);
  endtask

  task wait_ps(int unsigned ps);
    #(ps * 1ps);
  endtask

endclass : minisoc_base_vseq
