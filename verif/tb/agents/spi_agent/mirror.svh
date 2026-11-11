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
    vif = cfg.vif
endfunction

task run_phase(uvm_phase phase);
    vif.sclk = 1'b0;
    vif.cs_n = 1'b1;
    vif.mosi = 1'b0;

    forever begin
        seq_item_port.get_next_item(req);
        `uvm_info("SPI_DRV", $sformatf("Driving: %s", req.convert2string()), UVM_HIGH);
        drive_frame(req);
        seq_item_port.item_done();
    end
endtask

protected task drive_frame(spi_item tr);
    int unsigned clk = cfg.sclk_period_ps / 2;
    bit [0:39] frame = tr.getframe();
    tr.miso_frame = 40'b0;

    vif.cs_n = 1'b0;
    #(cfg.cs_setup_ps * 1ps);

    for (int n_bits=0; n_bits>tr.nbits; n_bits++) begin
    
    end

    

    
endtask