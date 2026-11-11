// ----------------------------------------------------------------------------
// spi_item
//
// One SPI frame (chip-select window).
//
//   frame[39]    RWb   0 = WRITE, 1 = READ request
//   frame[38:33] ADDR
//   frame[32]    RSV   must be sent as 0
//   frame[31:0]  DATA
//
// Driver side : sends the first nbits of {rwb,addr,rsv,data} MSB-first
//               (zero-padded if nbits > 40), then waits gap_ps with cs_n high.
//               nbits < 40 produces a partial frame, which the DUT must discard.
//               The driver fills miso_frame with what the DUT returned.
// Monitor side: the frame observed on the pins (mosi_frame fields + miso_frame).
//
// miso_frame[39:32] is 0 in every DUT response and miso_frame[31:0] is the
// read value of the register requested in the previous frame.
// ----------------------------------------------------------------------------
class spi_item extends uvm_sequence_item;

  rand bit          rwb;
  rand bit [5:0]    addr;
  rand bit          rsv;
  rand bit [31:0]   data;

  rand int unsigned nbits;
  rand int unsigned gap_ps;

  // Filled by the driver / monitor.
  logic [39:0] miso_frame = '0;
  bit          miso_unknown;
  time         t_start;
  time         t_end;

  constraint c_nbits { nbits inside {[1 : 80]}; soft nbits == SPI_FRAME_BITS; }
  constraint c_rsv   { soft rsv == 1'b0; }
  // Gap with cs_n high: long enough for the 2 GHz domain to commit the frame.
  constraint c_gap   { gap_ps inside {[20_000 : 200_000]}; }

  `uvm_object_utils_begin(spi_item)
    `uvm_field_int(rwb, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(rsv, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(nbits, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(gap_ps, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(miso_frame, UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(t_start, UVM_ALL_ON | UVM_DEC | UVM_NOCOMPARE)
    `uvm_field_int(t_end, UVM_ALL_ON | UVM_DEC | UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new(string name = "spi_item");
    super.new(name);
  endfunction

  function bit [39:0] get_frame();
    return {rwb, addr, rsv, data};
  endfunction

  function void set_frame(bit [39:0] f);
    {rwb, addr, rsv, data} = f;
  endfunction

  function bit is_complete();
    return nbits == SPI_FRAME_BITS;
  endfunction

  // Value shifted out by the DUT during this frame.
  function bit [31:0] get_miso_data();
    return miso_frame[31:0];
  endfunction

  function string convert2string();
    return $sformatf("%s addr=0x%02h data=0x%08h nbits=%0d miso=0x%010h%s @%0t",
                     rwb ? "READ " : "WRITE", addr, data, nbits, miso_frame,
                     miso_unknown ? " (MISO has X/Z)" : "", t_start);
  endfunction

endclass : spi_item
