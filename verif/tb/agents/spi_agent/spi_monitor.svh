// spi_monitor - rebuilds each 40-bit SPI frame from the pins
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
    ap = new("ap", this);
  endfunction

  task run_phase(uvm_phase phase);
    spi_item   tr;
    bit [39:0] mosi_frame;
    bit [39:0] miso_frame;

    forever begin
      // frame starts when cs_n goes low
      @(negedge vif.cs_n);
      tr = spi_item::type_id::create("tr");
      tr.t_start = $time;

      // MOSI and MISO are stable on the rising edge of sclk (CPOL=0, CPHA=0)
      for (int i = 39; i >= 0; i--) begin
        @(posedge vif.sclk);
        mosi_frame[i] = vif.mosi;
        miso_frame[i] = vif.miso;
      end

      tr.rwb        = mosi_frame[39];
      tr.addr       = mosi_frame[38:33];
      tr.rsv        = mosi_frame[32];
      tr.data       = mosi_frame[31:0];
      tr.miso_frame = miso_frame;
      tr.t_end      = $time;

      `uvm_info("SPI_MON", tr.convert2string(), UVM_MEDIUM)
      ap.write(tr);
    end
  endtask

endclass : spi_monitor
