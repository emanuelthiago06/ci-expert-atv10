// ----------------------------------------------------------------------------
// minisoc_spi_basic_vseq  (T-SPI-BASIC)
//
// First SPI bring-up, with local checks only (the register mirror / scoreboard
// comes later):
//   1) power-on reset
//   2) read reset values (Block Guide sections 6 and 8.1 / VPLAN F01)
//   3) write/read-back of a R/W register (KEY0)
//   4) write to a read-only register (VERSION) is ignored
//   5) read of an undefined address returns 0
// Every read also checks that MISO[39:32] is 0 and that MISO has no X/Z.
// ----------------------------------------------------------------------------
class minisoc_spi_basic_vseq extends minisoc_base_vseq;

  `uvm_object_utils(minisoc_spi_basic_vseq)

  localparam bit [31:0] VERSION_VALUE = 32'h0001_0100;

  function new(string name = "minisoc_spi_basic_vseq");
    super.new(name);
  endfunction

  task body();
    `uvm_info("SPI_BASIC", "1) Power-on reset", UVM_LOW)
    do_reset();
    wait_ps(50_000);

    `uvm_info("SPI_BASIC", "2) Reset values", UVM_LOW)
    check_reg(SPI_REG_VERSION,        VERSION_VALUE, "VERSION");
    check_reg(SPI_REG_SYSTEM_CONTROL, 32'h0000_000C, "SYSTEM_CONTROL");
    check_reg(SPI_REG_SYSTEM_STATUS,  32'h0000_0000, "SYSTEM_STATUS");
    check_reg(SPI_REG_NUM_BLOCKS,     32'h0000_0001, "NUM_BLOCKS");
    check_reg(SPI_REG_AES_CONTROL,    32'h0000_0000, "AES_CONTROL");
    check_reg(SPI_REG_AES_STATUS,     32'h0000_0000, "AES_STATUS");
    check_reg(SPI_REG_KEY0,           32'h0000_0000, "KEY0");

    `uvm_info("SPI_BASIC", "3) KEY0 write / read-back", UVM_LOW)
    spi_write(SPI_REG_KEY0, 32'hDEAD_BEEF);
    check_reg(SPI_REG_KEY0, 32'hDEAD_BEEF, "KEY0");

    `uvm_info("SPI_BASIC", "4) Write to read-only VERSION is ignored", UVM_LOW)
    spi_write(SPI_REG_VERSION, 32'hFFFF_FFFF);
    check_reg(SPI_REG_VERSION, VERSION_VALUE, "VERSION");

    `uvm_info("SPI_BASIC", "5) Undefined address reads as 0", UVM_LOW)
    check_reg(6'h20, 32'h0000_0000, "UNDEFINED(0x20)");
  endtask

  // CHK-SPI-00: read a register and compare it with the expected value.
  protected task check_reg(bit [5:0] addr, bit [31:0] expected, string name);
    bit [31:0] got;
    bit [7:0]  hdr;

    spi_read(addr, got, hdr);

    if (got !== expected)
      `uvm_error("CHK-SPI-00", $sformatf("%s (0x%02h): got 0x%08h, expected 0x%08h",
                                         name, addr, got, expected))
    else if (hdr !== 8'h00)
      `uvm_error("CHK-SPI-00", $sformatf("%s (0x%02h): MISO[39:32]=0x%02h, expected 0x00",
                                         name, addr, hdr))
    else
      `uvm_info("CHK-SPI-00", $sformatf("%s (0x%02h) = 0x%08h - OK", name, addr, got), UVM_LOW)
  endtask

endclass : minisoc_spi_basic_vseq
