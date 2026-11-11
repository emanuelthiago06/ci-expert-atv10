class spi_agent_cfg extends uvm_object;

`uvm_object_utils(spi_agent_cfg);

cfg = spi_agent_cfg::type_id::create("cfg");

virtual spi_if vif;

uvm_active_passive_enum is_active = UVM_ACTIVE;

int unsigned sclk_period_ps = 40_000;

int unsigned cs_setup_ps = 10_000;

int unsigned cs_hold_ps = 10_000;

function new(string name = "spi_agent_cfg");
    super.new(name);
endfunction

endclass : spi_agent_cfg