// spi_seq_lib - basic SPI register sequences

// write: one frame with RWb = 0
class spi_write_seq extends uvm_sequence #(spi_item);

  `uvm_object_utils(spi_write_seq)

  bit [5:0]  addr;
  bit [31:0] data;

  function new(string name = "spi_write_seq");
    super.new(name);
  endfunction

  task body();
    spi_item item = spi_item::type_id::create("item");

    start_item(item);
    item.rwb  = 1'b0;
    item.addr = addr;
    item.data = data;
    finish_item(item);
  endtask

endclass : spi_write_seq


// read: two frames
//   frame 1 -> READ + addr (DUT loads the register value)
//   frame 2 -> NOP, the DUT shifts the value out on MISO
class spi_read_seq extends uvm_sequence #(spi_item);

  `uvm_object_utils(spi_read_seq)

  bit [5:0]  addr;
  bit [31:0] rdata;   // MISO[31:0] of frame 2
  bit [7:0]  rhdr;    // MISO[39:32] of frame 2, should be 0

  function new(string name = "spi_read_seq");
    super.new(name);
  endfunction

  task body();
    spi_item item1 = spi_item::type_id::create("item1");
    spi_item item2 = spi_item::type_id::create("item2");

    start_item(item1);
    item1.rwb  = 1'b1;
    item1.addr = addr;
    item1.data = '0;
    finish_item(item1);

    start_item(item2);
    item2.rwb  = 1'b1;
    item2.addr = SPI_REG_NOP;
    item2.data = '0;
    finish_item(item2);

    // the driver fills miso_frame while it drives the frame
    rdata = item2.miso_frame[31:0];
    rhdr  = item2.miso_frame[39:32];
  endtask

endclass : spi_read_seq
