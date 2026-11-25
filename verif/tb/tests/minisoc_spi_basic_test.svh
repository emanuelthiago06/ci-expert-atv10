// minisoc_spi_basic_test (T-SPI-BASIC)
//   1) reset
//   2) read the reset value of the registers
//   3) write KEY0 and read it back
//   4) write to VERSION (read-only), value must not change
//   5) read an undefined address, must return 0
class minisoc_spi_basic_test extends minisoc_base_test;

  `uvm_component_utils(minisoc_spi_basic_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("SPI_TEST", "1) Reset", UVM_LOW)
    reset_dut(10_000);
    #50ns;

    `uvm_info("SPI_TEST", "2) Reset values", UVM_LOW)
    check_reg(SPI_REG_VERSION,        32'h0001_0100, "VERSION");
    check_reg(SPI_REG_SYSTEM_CONTROL, 32'h0000_000C, "SYSTEM_CONTROL");
    check_reg(SPI_REG_SYSTEM_STATUS,  32'h0000_0000, "SYSTEM_STATUS");
    check_reg(SPI_REG_NUM_BLOCKS,     32'h0000_0001, "NUM_BLOCKS");
    check_reg(SPI_REG_AES_CONTROL,    32'h0000_0000, "AES_CONTROL");
    check_reg(SPI_REG_AES_STATUS,     32'h0000_0000, "AES_STATUS");
    check_reg(SPI_REG_KEY0,           32'h0000_0000, "KEY0");

    `uvm_info("SPI_TEST", "3) Write KEY0 and read back", UVM_LOW)
    spi_write(SPI_REG_KEY0, 32'hDEAD_BEEF);
    check_reg(SPI_REG_KEY0, 32'hDEAD_BEEF, "KEY0");

    `uvm_info("SPI_TEST", "4) Write to VERSION is ignored", UVM_LOW)
    spi_write(SPI_REG_VERSION, 32'hFFFF_FFFF);
    check_reg(SPI_REG_VERSION, 32'h0001_0100, "VERSION");

    `uvm_info("SPI_TEST", "5) Undefined address reads 0", UVM_LOW)
    check_reg(6'h20, 32'h0000_0000, "UNDEFINED");

    #100ns;
    phase.drop_objection(this);
  endtask

  task spi_write(bit [5:0] addr, bit [31:0] data);
    spi_write_seq wr_seq;
    wr_seq = spi_write_seq::type_id::create("wr_seq");
    wr_seq.addr = addr;
    wr_seq.data = data;
    wr_seq.start(env.spi_agt.sqr);
  endtask

  // CHK-SPI-00: read a register and compare with the expected value
  task check_reg(bit [5:0] addr, bit [31:0] expected, string name);
    spi_read_seq rd_seq;
    rd_seq = spi_read_seq::type_id::create("rd_seq");
    rd_seq.addr = addr;
    rd_seq.start(env.spi_agt.sqr);

    if (rd_seq.rdata == expected)
      `uvm_info("CHK-SPI-00", $sformatf("%s = 0x%08h - OK", name, rd_seq.rdata), UVM_LOW)
    else
      `uvm_error("CHK-SPI-00", $sformatf("%s = 0x%08h, expected 0x%08h", name, rd_seq.rdata, expected))
  endtask

endclass : minisoc_spi_basic_test
