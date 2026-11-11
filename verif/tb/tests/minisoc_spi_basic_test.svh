// ----------------------------------------------------------------------------
// minisoc_spi_basic_test (T-SPI-BASIC)
// ----------------------------------------------------------------------------
class minisoc_spi_basic_test extends minisoc_base_test;

  `uvm_component_utils(minisoc_spi_basic_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function minisoc_base_vseq create_vseq();
    minisoc_spi_basic_vseq vseq = minisoc_spi_basic_vseq::type_id::create("vseq");
    return vseq;
  endfunction

endclass : minisoc_spi_basic_test
