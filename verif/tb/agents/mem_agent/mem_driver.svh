// mem_driver - one transaction = one mem_clk cycle
//   write: memory[addr] <= wdata on the rising edge
//   read : mem_o_data <= memory[addr] on the rising edge, so the data is
//          read back at the falling edge of the same cycle
class mem_driver extends uvm_driver #(mem_item);

  `uvm_component_utils(mem_driver)

  mem_agent_cfg  cfg;
  virtual mem_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(mem_agent_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("NOCFG", "mem_agent_cfg not found")
    vif = cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    // idle: wr_en = 0 so nothing is written
    vif.wr_en = 1'b0;
    vif.addr  = '0;
    vif.wdata = '0;
    vif.valid = 1'b0;

    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info("MEM_DRV", $sformatf("Driving: %s", req.convert2string()), UVM_HIGH)
      drive_item(req);
      seq_item_port.item_done();
    end
  endtask

  task drive_item(mem_item tr);
    // put the transaction on the bus
    @(posedge vif.clk);
    vif.wr_en <= tr.wr;
    vif.addr  <= tr.addr;
    vif.wdata <= tr.wr ? tr.data : '0;
    vif.valid <= 1'b1;

    // the memory samples it on this edge
    @(posedge vif.clk);
    vif.wr_en <= 1'b0;
    vif.valid <= 1'b0;

    // read: the data is in mem_o_data after the edge
    if (!tr.wr) begin
      @(negedge vif.clk);
      tr.data = vif.rdata;
    end
  endtask

endclass : mem_driver
