// minisoc_base_test - creates the env, the other tests extend this class
class minisoc_base_test extends uvm_test;

  `uvm_component_utils(minisoc_base_test)

  minisoc_env     env;
  minisoc_env_cfg cfg;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    cfg = minisoc_env_cfg::type_id::create("cfg");

    // interfaces come from tb_top
    if (!uvm_config_db#(virtual clk_if)::get(this, "", "ref_clk_vif", cfg.ref_clk_cfg.vif))
      `uvm_fatal("NOVIF", "ref_clk_vif not found")
    if (!uvm_config_db#(virtual clk_if)::get(this, "", "mem_clk_vif", cfg.mem_clk_cfg.vif))
      `uvm_fatal("NOVIF", "mem_clk_vif not found")
    if (!uvm_config_db#(virtual clk_if)::get(this, "", "sys_clk_vif", cfg.sys_clk_cfg.vif))
      `uvm_fatal("NOVIF", "sys_clk_vif not found")
    if (!uvm_config_db#(virtual rst_if)::get(this, "", "rst_vif", cfg.rst_cfg.vif))
      `uvm_fatal("NOVIF", "rst_vif not found")
    if (!uvm_config_db#(virtual spi_if)::get(this, "", "spi_vif", cfg.spi_cfg.vif))
      `uvm_fatal("NOVIF", "spi_vif not found")
    if (!uvm_config_db#(virtual mem_if)::get(this, "", "mem_vif", cfg.mem_cfg.vif))
      `uvm_fatal("NOVIF", "mem_vif not found")

    uvm_config_db#(minisoc_env_cfg)::set(this, "env", "cfg", cfg);
    env = minisoc_env::type_id::create("env", this);

    // stop the simulation if something hangs
    uvm_top.set_timeout(1ms, 0);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  // reset pulse on rst_n, used by all tests
  task reset_dut(int unsigned width_ps);
    rst_pulse_seq rst_seq;
    rst_seq = rst_pulse_seq::type_id::create("rst_seq");
    rst_seq.pre_delay_ps = 1_000;
    rst_seq.width_ps     = width_ps;
    rst_seq.start(env.rst_agt.sqr);
  endtask

  // the Makefile looks for "TEST PASSED" in the log
  function void report_phase(uvm_phase phase);
    uvm_report_server srv = uvm_report_server::get_server();

    if (srv.get_severity_count(UVM_ERROR) == 0 && srv.get_severity_count(UVM_FATAL) == 0)
      `uvm_info("RESULT", "*** TEST PASSED ***", UVM_NONE)
    else
      `uvm_info("RESULT", "*** TEST FAILED ***", UVM_NONE)
  endfunction

endclass : minisoc_base_test
