// ----------------------------------------------------------------------------
// rst_driver
// ----------------------------------------------------------------------------
class rst_driver extends uvm_driver #(rst_item);

  `uvm_component_utils(rst_driver)

  rst_agent_cfg  cfg;
  virtual rst_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(rst_agent_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("NOCFG", "rst_agent_cfg not found")
    vif = cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    // Deasserted at time 0 so that the first reset is a real negedge.
    vif.rst_n = 1'b1;

    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info("RST_DRV", $sformatf("Reset pulse: pre_delay=%0dps width=%0dps",
                                     req.pre_delay_ps, req.width_ps), UVM_HIGH)

      #(req.pre_delay_ps * 1ps);
      vif.rst_n = 1'b0;
      #(req.width_ps * 1ps);
      vif.rst_n = 1'b1;

      seq_item_port.item_done();
    end
  endtask

endclass : rst_driver
