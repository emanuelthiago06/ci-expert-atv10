// ----------------------------------------------------------------------------
// spi_monitor
//
// Observes the pins only (it does not look at what the driver was asked to
// send). One item is published per chip-select window: mosi and miso are
// sampled on every sclk rising edge while cs_n is low. A window with fewer
// than 40 clocks is published as a partial frame (nbits < 40).
// ----------------------------------------------------------------------------
class spi_monitor extends uvm_monitor;

  `uvm_component_utils(spi_monitor)

  spi_agent_cfg  cfg;
  virtual spi_if vif;

  uvm_analysis_port #(spi_item) ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(spi_agent_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("NOCFG", "spi_agent_cfg not found")
    vif = cfg.vif;
    ap  = new("ap", this);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      @(negedge vif.cs_n);
      collect_frame();
    end
  endtask

  protected task collect_frame();
    logic   mosi_q[$];
    logic   miso_q[$];
    time    t_start = $time;

    fork
      begin
        fork
          forever begin
            @(posedge vif.sclk);
            mosi_q.push_back(vif.mosi);
            miso_q.push_back(vif.miso);
          end
          @(posedge vif.cs_n);
        join_any
        disable fork;
      end
    join

    publish(mosi_q, miso_q, t_start);
  endtask

  protected function void publish(logic mosi_q[$], logic miso_q[$], time t_start);
    spi_item     tr = spi_item::type_id::create("tr");
    bit [39:0]   mosi_frame = '0;

    tr.miso_frame   = '0;
    tr.miso_unknown = 1'b0;
    tr.nbits        = mosi_q.size();
    tr.t_start      = t_start;
    tr.t_end        = $time;

    for (int i = 0; i < mosi_q.size() && i < SPI_FRAME_BITS; i++) begin
      mosi_frame[SPI_FRAME_BITS-1-i]    = mosi_q[i];
      tr.miso_frame[SPI_FRAME_BITS-1-i] = miso_q[i];
      if ($isunknown(miso_q[i])) tr.miso_unknown = 1'b1;
    end
    tr.set_frame(mosi_frame);

    `uvm_info("SPI_MON", tr.convert2string(), UVM_MEDIUM)
    ap.write(tr);
  endfunction

endclass : spi_monitor
