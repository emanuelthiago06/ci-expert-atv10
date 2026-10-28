// ----------------------------------------------------------------------------
// clk_driver
//
// Generates a 50% duty-cycle clock in a background process. Each item either
// restarts the generator with a new period or stops it (clock held low).
// ----------------------------------------------------------------------------
class clk_driver extends uvm_driver #(clk_item);

  `uvm_component_utils(clk_driver)

  clk_agent_cfg  cfg;
  virtual clk_if vif;

  protected process gen_proc;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(clk_agent_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("NOCFG", "clk_agent_cfg not found")
    vif = cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    vif.clk = 1'b0;

    if (cfg.auto_start)
      start_clock(cfg.init_period_ps);

    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info("CLK_DRV", req.convert2string(), UVM_HIGH)

      if (req.op == CLK_START)
        start_clock(req.period_ps);
      else
        stop_clock();

      seq_item_port.item_done();
    end
  endtask

  protected task start_clock(int unsigned period_ps);
    time half;

    if (period_ps < 2 || period_ps % 2 != 0)
      `uvm_fatal("CLK_PERIOD", $sformatf("Illegal clock period %0dps", period_ps))

    stop_clock();
    half = (period_ps / 2) * 1ps;

    fork
      begin
        gen_proc = process::self();
        forever begin
          #(half) vif.clk = 1'b1;
          #(half) vif.clk = 1'b0;
        end
      end
    join_none

    wait (gen_proc != null);
  endtask

  protected task stop_clock();
    if (gen_proc != null) begin
      gen_proc.kill();
      gen_proc = null;
    end
    vif.clk = 1'b0;
  endtask

endclass : clk_driver
