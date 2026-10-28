// ----------------------------------------------------------------------------
// minisoc_base_test
//
// Builds the env configuration from the virtual interfaces published by
// tb_top, runs the virtual sequence returned by create_vseq() and prints a
// PASS/FAIL banner (UVM_ERROR/UVM_FATAL count, SVA failures included).
//
// Plusargs:
//   +MEM_CLK_PERIOD_PS=<ps>    mem_clk period (default 10000 = 100 MHz)
// ----------------------------------------------------------------------------
class minisoc_base_test extends uvm_test;

  `uvm_component_utils(minisoc_base_test)

  minisoc_env     env;
  minisoc_env_cfg cfg;

  // Simulation watchdog.
  time test_timeout = 1ms;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    cfg = minisoc_env_cfg::type_id::create("cfg");

    if (!uvm_config_db#(virtual clk_if)::get(this, "", "ref_clk_vif", cfg.ref_clk_cfg.vif))
      `uvm_fatal("NOVIF", "ref_clk_vif not found")
    if (!uvm_config_db#(virtual clk_if)::get(this, "", "mem_clk_vif", cfg.mem_clk_cfg.vif))
      `uvm_fatal("NOVIF", "mem_clk_vif not found")
    if (!uvm_config_db#(virtual clk_if)::get(this, "", "sys_clk_vif", cfg.sys_clk_cfg.vif))
      `uvm_fatal("NOVIF", "sys_clk_vif not found")
    if (!uvm_config_db#(virtual rst_if)::get(this, "", "rst_vif", cfg.rst_cfg.vif))
      `uvm_fatal("NOVIF", "rst_vif not found")

    void'($value$plusargs("MEM_CLK_PERIOD_PS=%d", cfg.mem_clk_cfg.init_period_ps));

    configure(cfg);

    uvm_config_db#(minisoc_env_cfg)::set(this, "env", "cfg", cfg);
    env = minisoc_env::type_id::create("env", this);

    uvm_top.set_timeout(test_timeout, 0);
  endfunction

  // Hook for derived tests to adjust the configuration.
  virtual function void configure(minisoc_env_cfg cfg);
  endfunction

  // Hook for derived tests: the virtual sequence to run.
  virtual function minisoc_base_vseq create_vseq();
    return null;
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    minisoc_base_vseq vseq = create_vseq();

    if (vseq == null)
      `uvm_fatal("NOVSEQ", "create_vseq() returned null")

    phase.raise_objection(this);
    `uvm_info("TEST", $sformatf("Running %s", vseq.get_type_name()), UVM_LOW)
    vseq.start(env.vsqr);
    #(100ns);  // drain: let monitors see the last events
    phase.drop_objection(this);
  endtask

  function void report_phase(uvm_phase phase);
    uvm_report_server srv = uvm_report_server::get_server();
    int n_err = srv.get_severity_count(UVM_ERROR) + srv.get_severity_count(UVM_FATAL);
    string seed = "?";

    void'($value$plusargs("ntb_random_seed=%s", seed));

    if (n_err == 0)
      `uvm_info("RESULT", $sformatf("\n\n*** TEST PASSED *** %s seed=%s\n",
                                    get_type_name(), seed), UVM_NONE)
    else
      `uvm_info("RESULT", $sformatf("\n\n*** TEST FAILED *** %s seed=%s errors=%0d\n",
                                    get_type_name(), seed, n_err), UVM_NONE)
  endfunction

endclass : minisoc_base_test
