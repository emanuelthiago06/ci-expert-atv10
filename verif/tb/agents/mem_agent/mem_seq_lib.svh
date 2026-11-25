// mem_seq_lib - basic memory sequences

// write one word
class mem_write_seq extends uvm_sequence #(mem_item);

  `uvm_object_utils(mem_write_seq)

  bit [9:0]  addr;
  bit [31:0] data;

  function new(string name = "mem_write_seq");
    super.new(name);
  endfunction

  task body();
    mem_item item = mem_item::type_id::create("item");

    start_item(item);
    item.wr   = 1'b1;
    item.addr = addr;
    item.data = data;
    finish_item(item);
  endtask

endclass : mem_write_seq


// read one word
class mem_read_seq extends uvm_sequence #(mem_item);

  `uvm_object_utils(mem_read_seq)

  bit [9:0]  addr;
  bit [31:0] rdata;   // filled after the read

  function new(string name = "mem_read_seq");
    super.new(name);
  endfunction

  task body();
    mem_item item = mem_item::type_id::create("item");

    start_item(item);
    item.wr   = 1'b0;
    item.addr = addr;
    item.data = '0;
    finish_item(item);

    // the driver puts the read data in item.data
    rdata = item.data;
  endtask

endclass : mem_read_seq
