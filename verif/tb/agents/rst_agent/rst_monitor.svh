// ----------------------------------------------------------------------------
// rst_monitor
//
// Publishes every reset edge through the analysis port, so subscribers can
// use RST_ASSERT to flush their state and RST_DEASSERT to resume.
// ----------------------------------------------------------------------------
class rst_monitor extends uvm_monitor;

  `uvm_component_utils(rst_monitor)

  rst_agent_cfg  cfg;
  virtual rst_if vif;

  uvm_analysis_port #(rst_item) ap;

  protected bit in_reset;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(rst_agent_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("NOCFG", "rst_agent_cfg not found")
    vif = cfg.vif;
    ap  = new("ap", this);
  endfunction

  function bit is_in_reset();
    return in_reset;
  endfunction

  task run_phase(uvm_phase phase);
    time t_assert;

    forever begin
      @(negedge vif.rst_n);
      t_assert = $time;
      in_reset = 1'b1;
      publish(RST_ASSERT, t_assert, 0);

      @(posedge vif.rst_n);
      in_reset = 1'b0;
      publish(RST_DEASSERT, $time, ($time - t_assert) / 1ps);
    end
  endtask

  protected function void publish(rst_evt_e evt, time t, int unsigned width);
    rst_item tr = rst_item::type_id::create("tr");
    tr.evt      = evt;
    tr.t_event  = t;
    tr.width_ps = width;
    `uvm_info("RST_MON", tr.convert2string(), UVM_MEDIUM)
    ap.write(tr);
  endfunction

endclass : rst_monitor
