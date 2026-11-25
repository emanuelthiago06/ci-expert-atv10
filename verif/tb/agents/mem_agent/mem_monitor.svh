// mem_monitor - collects every memory write/read done on the external interface
class mem_monitor extends uvm_monitor;

  `uvm_component_utils(mem_monitor)

  mem_agent_cfg  cfg;
  virtual mem_if vif;

  uvm_analysis_port #(mem_item) ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(mem_agent_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("NOCFG", "mem_agent_cfg not found")
    vif = cfg.vif;
    ap = new("ap", this);
  endfunction

  task run_phase(uvm_phase phase);
    mem_item tr;

    forever begin
      @(posedge vif.clk);

      if (vif.valid === 1'b1) begin
        tr = mem_item::type_id::create("tr");
        tr.wr   = vif.wr_en;
        tr.addr = vif.addr;

        if (vif.wr_en) begin
          tr.data = vif.wdata;
        end
        else begin
          // read data is ready after the edge
          @(negedge vif.clk);
          tr.data = vif.rdata;
        end

        `uvm_info("MEM_MON", tr.convert2string(), UVM_MEDIUM)
        ap.write(tr);
      end
    end
  endtask

endclass : mem_monitor
