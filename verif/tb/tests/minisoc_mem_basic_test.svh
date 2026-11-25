// minisoc_mem_basic_test (T-MEM-BASIC)
//   1) reset (after reset MEM_SEL_AES = 0, so the external interface owns the memory)
//   2) write some addresses, including the first and the last one
//   3) read them back and compare
class minisoc_mem_basic_test extends minisoc_base_test;

  `uvm_component_utils(minisoc_mem_basic_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("MEM_TEST", "1) Reset", UVM_LOW)
    reset_dut(10_000);
    #50ns;

    `uvm_info("MEM_TEST", "2) Write", UVM_LOW)
    for (int i = 0; i < 8; i++)
      mem_write(i, 32'hA5A5_0000 + i);
    mem_write(10'h3FF, 32'hDEAD_BEEF);

    `uvm_info("MEM_TEST", "3) Read back", UVM_LOW)
    for (int i = 0; i < 8; i++)
      check_mem(i, 32'hA5A5_0000 + i);
    check_mem(10'h3FF, 32'hDEAD_BEEF);

    #100ns;
    phase.drop_objection(this);
  endtask

  task mem_write(bit [9:0] addr, bit [31:0] data);
    mem_write_seq wr_seq;
    wr_seq = mem_write_seq::type_id::create("wr_seq");
    wr_seq.addr = addr;
    wr_seq.data = data;
    wr_seq.start(env.mem_agt.sqr);
  endtask

  // CHK-MEM-00: read an address and compare with the value written before
  task check_mem(bit [9:0] addr, bit [31:0] expected);
    mem_read_seq rd_seq;
    rd_seq = mem_read_seq::type_id::create("rd_seq");
    rd_seq.addr = addr;
    rd_seq.start(env.mem_agt.sqr);

    if (rd_seq.rdata == expected)
      `uvm_info("CHK-MEM-00", $sformatf("addr 0x%03h = 0x%08h - OK", addr, rd_seq.rdata), UVM_LOW)
    else
      `uvm_error("CHK-MEM-00", $sformatf("addr 0x%03h = 0x%08h, expected 0x%08h",
                                         addr, rd_seq.rdata, expected))
  endtask

endclass : minisoc_mem_basic_test
