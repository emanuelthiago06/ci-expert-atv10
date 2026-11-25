// mem_if - external MEMORY DATA interface
interface mem_if;
  logic        clk;     // mem_clk, connected in tb_top
  logic [31:0] wdata;   // -> mem_i_data
  logic        wr_en;   // -> mem_i_wr_en (1 = write, 0 = read)
  logic [9:0]  addr;    // -> mem_i_addr
  logic [31:0] rdata;   // <- mem_o_data

  // testbench only (not a DUT pin): 1 in the cycle of a real transaction,
  // so the monitor knows when to collect. The memory reads every cycle when
  // wr_en = 0, so without this the monitor would see a read on every clock.
  logic        valid;
endinterface : mem_if
