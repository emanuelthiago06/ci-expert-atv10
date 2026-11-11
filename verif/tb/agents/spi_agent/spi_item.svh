class spi_item extends uvm_sequence_item;

rand bit rwb;
rand bit [5:0] addr;
bit rsv;
rand bit [31:0] data;

rand int unsigned nbits;

rand int unsigned gap_ps;

bit [39:0] miso_frame = '0

time t_start;
time t_end;

`uvm_object_utils(spi_item);

  function new(string name = "spi_item");
    super.new(name);
  endfunction

  function string convert2string();
    return $sformatf("%s addr=0x%02h data=0x%08h nbits=%0d miso=0x%010h%s @%0t",
                     rwb ? "READ " : "WRITE", addr, data, nbits, miso_frame,
                     miso_unknown ? " (MISO has X/Z)" : "", t_start);
  endfunction

endclass: spi_item