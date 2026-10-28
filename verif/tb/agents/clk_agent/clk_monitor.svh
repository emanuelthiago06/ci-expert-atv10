// ----------------------------------------------------------------------------
// clk_monitor
//
// Measures the clock on vif.clk and publishes only state changes:
//   CLK_START : clock became stable with a new period (first start or a
//               frequency change), after cfg.stable_edges equal periods.
//   CLK_STOP  : no rising edge during cfg.stop_timeout_ps. t_event is the time
//               of the last rising edge seen.
// Publishing per state change (not per edge) keeps the 2 GHz clock cheap.
// ----------------------------------------------------------------------------
class clk_monitor extends uvm_monitor;

  `uvm_component_utils(clk_monitor)

  clk_agent_cfg  cfg;
  virtual clk_if vif;

  uvm_analysis_port #(clk_item) ap;

  protected time         last_edge;
  protected bit          last_edge_valid;
  protected time         cand_period;
  protected int unsigned stable_cnt;
  protected bit          running;
  protected time         reported_period;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(clk_agent_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("NOCFG", "clk_agent_cfg not found")
    vif = cfg.vif;
    ap  = new("ap", this);
  endfunction

  task run_phase(uvm_phase phase);
    fork
      track_edges();
      stop_watchdog();
    join
  endtask

  // Is the clock currently running? Usable by sequences/checkers.
  function bit is_running();
    return running;
  endfunction

  function time get_period();
    return running ? reported_period : 0;
  endfunction

  protected task track_edges();
    time now, p;

    forever begin
      @(posedge vif.clk);
      // 0->X is a posedge too: before the first reset the gated sys_clk
      // toggles between 0 and X. Only real rising edges (ending in 1) count.
      if (vif.clk !== 1'b1)
        continue;
      now = $time;

      if (last_edge_valid) begin
        p = now - last_edge;

        if (p == cand_period) begin
          stable_cnt++;
        end
        else begin
          cand_period = p;
          stable_cnt  = 1;
        end

        if (stable_cnt == cfg.stable_edges && (!running || p != reported_period)) begin
          running         = 1'b1;
          reported_period = p;
          publish(CLK_START, p, now);
        end
      end

      last_edge       = now;
      last_edge_valid = 1'b1;
    end
  endtask

  protected task stop_watchdog();
    time check_interval = (cfg.stop_timeout_ps / 4) * 1ps;

    forever begin
      #(check_interval);
      if (last_edge_valid && ($time - last_edge) > cfg.stop_timeout_ps * 1ps) begin
        last_edge_valid = 1'b0;
        stable_cnt      = 0;
        cand_period     = 0;
        if (running) begin
          running = 1'b0;
          publish(CLK_STOP, 0, last_edge);
        end
      end
    end
  endtask

  protected function void publish(clk_op_e op, time period, time t);
    clk_item tr = clk_item::type_id::create("tr");
    tr.op        = op;
    tr.period_ps = period / 1ps;
    tr.t_event   = t;
    `uvm_info("CLK_MON", tr.convert2string(), UVM_MEDIUM)
    ap.write(tr);
  endfunction

endclass : clk_monitor
