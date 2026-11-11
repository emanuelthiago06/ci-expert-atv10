// ----------------------------------------------------------------------------
// spi_driver
//
// SPI master, Mode 0:
//   - cs_n falls, then after cs_setup_ps the first sclk period starts;
//   - mosi changes on the falling edge (stable half a period before the
//     rising edge, where the DUT samples it);
//   - miso is sampled on the rising edge (the DUT updates it on the falling
//     edge), MSB-first.
// ----------------------------------------------------------------------------
class spi_driver extends uvm_driver #(spi_item);

  `uvm_component_utils(spi_driver)

  spi_agent_cfg  cfg;
  virtual spi_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(spi_agent_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("NOCFG", "spi_agent_cfg not found")
    vif = cfg.vif;
  endfunction

  function void start_of_simulation_phase(uvm_phase phase);
    if (cfg.sclk_period_ps < 40_000)
      `uvm_warning("SPI_DRV", $sformatf(
        "sclk_period_ps=%0d is above 25 MHz (REQ-SPI-01 violated)", cfg.sclk_period_ps))
  endfunction

  task run_phase(uvm_phase phase);
    // Idle state at time 0.
    vif.sclk = 1'b0;
    vif.cs_n = 1'b1;
    vif.mosi = 1'b0;

    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info("SPI_DRV", $sformatf("Driving: %s", req.convert2string()), UVM_HIGH)
      drive_frame(req);
      seq_item_port.item_done();
    end
  endtask

  protected task drive_frame(spi_item tr);
    int unsigned half = cfg.sclk_period_ps / 2;
    bit [39:0]   frame = tr.get_frame();
    bit          bit_out;

    tr.miso_frame   = '0;
    tr.miso_unknown = 1'b0;
    tr.t_start      = $time;

    vif.cs_n = 1'b0;
    #(cfg.cs_setup_ps * 1ps);

    for (int i = 0; i < tr.nbits; i++) begin
      bit_out  = (i < SPI_FRAME_BITS) ? frame[SPI_FRAME_BITS-1-i] : 1'b0;
      vif.mosi = bit_out;
      #(half * 1ps);

      vif.sclk = 1'b1;                      // DUT samples mosi here
      if (i < SPI_FRAME_BITS) begin
        if ($isunknown(vif.miso)) tr.miso_unknown = 1'b1;
        tr.miso_frame[SPI_FRAME_BITS-1-i] = vif.miso;
      end
      #(half * 1ps);

      vif.sclk = 1'b0;                      // DUT updates miso here
    end

    #(cfg.cs_hold_ps * 1ps);
    vif.cs_n = 1'b1;
    vif.mosi = 1'b0;
    tr.t_end = $time;

    #(tr.gap_ps * 1ps);
  endtask

endclass : spi_driver
