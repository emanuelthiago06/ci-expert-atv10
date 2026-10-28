// ----------------------------------------------------------------------------
// minisoc_smoke_test (T-SMOKE)
// ----------------------------------------------------------------------------
class minisoc_smoke_test extends minisoc_base_test;

  `uvm_component_utils(minisoc_smoke_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function minisoc_base_vseq create_vseq();
    minisoc_smoke_vseq vseq = minisoc_smoke_vseq::type_id::create("vseq");
    if (!vseq.randomize())
      `uvm_fatal("RAND", "minisoc_smoke_vseq randomization failed")
    return vseq;
  endfunction

endclass : minisoc_smoke_test
