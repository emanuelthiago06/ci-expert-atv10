// ----------------------------------------------------------------------------
// Clock sequences
// ----------------------------------------------------------------------------

// Start (or retune) the clock. period_ps can be fixed by the caller or left
// random within [min_period_ps, max_period_ps].
class clk_start_seq extends uvm_sequence #(clk_item);

  `uvm_object_utils(clk_start_seq)

  rand int unsigned period_ps;
  int unsigned      min_period_ps = 500;
  int unsigned      max_period_ps = 500;

  constraint c_range {
    period_ps inside {[min_period_ps : max_period_ps]};
    period_ps % 2 == 0;
  }

  function new(string name = "clk_start_seq");
    super.new(name);
  endfunction

  task body();
    req = clk_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with { op == CLK_START; period_ps == local::period_ps; })
      `uvm_fatal("RAND", "clk_item randomization failed")
    finish_item(req);
  endtask

endclass : clk_start_seq


class clk_stop_seq extends uvm_sequence #(clk_item);

  `uvm_object_utils(clk_stop_seq)

  function new(string name = "clk_stop_seq");
    super.new(name);
  endfunction

  task body();
    req = clk_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with { op == CLK_STOP; })
      `uvm_fatal("RAND", "clk_item randomization failed")
    finish_item(req);
  endtask

endclass : clk_stop_seq
