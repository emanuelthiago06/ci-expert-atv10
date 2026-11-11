// ----------------------------------------------------------------------------
// SPI sequences
// ----------------------------------------------------------------------------

// One raw frame. Every knob (including rsv and nbits) can be pinned with
// randomize() with {}; used for partial frames and reserved-bit tests.
class spi_frame_seq extends uvm_sequence #(spi_item);

  `uvm_object_utils(spi_frame_seq)

  rand bit          rwb;
  rand bit [5:0]    addr;
  rand bit          rsv;
  rand bit [31:0]   data;
  rand int unsigned nbits;
  rand int unsigned gap_ps;

  // Result: what the DUT shifted out during this frame.
  logic [39:0] miso_frame;

  constraint c_default {
    soft rsv   == 1'b0;
    soft nbits == SPI_FRAME_BITS;
    soft gap_ps inside {[20_000 : 100_000]};
  }

  function new(string name = "spi_frame_seq");
    super.new(name);
  endfunction

  task body();
    req = spi_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with { rwb    == local::rwb;
                                addr   == local::addr;
                                rsv    == local::rsv;
                                data   == local::data;
                                nbits  == local::nbits;
                                gap_ps == local::gap_ps; })
      `uvm_fatal("RAND", "spi_item randomization failed")
    finish_item(req);
    miso_frame = req.miso_frame;
  endtask

endclass : spi_frame_seq


// Register write: one frame.
class spi_write_seq extends uvm_sequence #(spi_item);

  `uvm_object_utils(spi_write_seq)

  rand bit [5:0]  addr;
  rand bit [31:0] data;

  function new(string name = "spi_write_seq");
    super.new(name);
  endfunction

  task body();
    spi_frame_seq f = spi_frame_seq::type_id::create("wr_frame");
    if (!f.randomize() with { rwb == 1'b0;
                              addr == local::addr;
                              data == local::data; })
      `uvm_fatal("RAND", "spi_frame_seq randomization failed")
    f.start(m_sequencer, this);
  endtask

endclass : spi_write_seq


// Register read: two frames.
//   Frame A: READ request with the register address.
//   Frame B: NOP frame during which the DUT shifts the value out on MISO.
// Frame B is a READ of the NOP address (0x3F): it has no side effect on the
// register bank, unlike a write frame.
class spi_read_seq extends uvm_sequence #(spi_item);

  `uvm_object_utils(spi_read_seq)

  rand bit [5:0] addr;

  // Results.
  bit [31:0] rdata;
  bit [7:0]  rhdr;      // miso_frame[39:32]; 0 in a correct DUT response
  bit        miso_unknown;

  function new(string name = "spi_read_seq");
    super.new(name);
  endfunction

  task body();
    spi_frame_seq a = spi_frame_seq::type_id::create("rd_req");
    spi_frame_seq b = spi_frame_seq::type_id::create("rd_nop");

    if (!a.randomize() with { rwb == 1'b1; addr == local::addr; data == 32'h0; })
      `uvm_fatal("RAND", "spi_frame_seq randomization failed")
    a.start(m_sequencer, this);

    if (!b.randomize() with { rwb == 1'b1; addr == 6'h3F; data == 32'h0; })
      `uvm_fatal("RAND", "spi_frame_seq randomization failed")
    b.start(m_sequencer, this);

    rdata        = b.miso_frame[31:0];
    rhdr         = b.miso_frame[39:32];
    miso_unknown = $isunknown(b.miso_frame);
  endtask

endclass : spi_read_seq
