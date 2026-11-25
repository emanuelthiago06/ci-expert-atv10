class mem_item extends uvm_sequence_item;

  rand bit        wr;     // 1 = write, 0 = read
  rand bit [9:0]  addr;
  rand bit [31:0] data;   // write: data to write / read: data read (filled by the driver)

  `uvm_object_utils(mem_item)

  function new(string name = "mem_item");
    super.new(name);
  endfunction

  function string convert2string();
    return $sformatf("%s addr=0x%03h data=0x%08h", wr ? "WRITE" : "READ ", addr, data);
  endfunction

endclass : mem_item
