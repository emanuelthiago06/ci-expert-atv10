// ----------------------------------------------------------------------------
// spi_agent_cfg
//
// All times are integer picoseconds.
//   sclk_period_ps : REQ-SPI-01 limits sclk to 25 MHz, i.e. >= 40_000 ps.
//   cs_setup_ps    : cs_n falling -> start of the first sclk period.
//   cs_hold_ps     : last sclk falling edge -> cs_n rising.
// ----------------------------------------------------------------------------
class spi_agent_cfg extends uvm_object;

  `uvm_object_utils(spi_agent_cfg)

  virtual spi_if vif;

  uvm_active_passive_enum is_active = UVM_ACTIVE;

  int unsigned sclk_period_ps = 40_000;   // 25 MHz
  int unsigned cs_setup_ps    = 10_000;
  int unsigned cs_hold_ps     = 10_000;

  function new(string name = "spi_agent_cfg");
    super.new(name);
  endfunction

endclass : spi_agent_cfg
