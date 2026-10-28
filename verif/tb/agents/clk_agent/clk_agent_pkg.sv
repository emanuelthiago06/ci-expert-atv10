`timescale 1ps/1ps

// ----------------------------------------------------------------------------
// clk_agent_pkg
//
// Clock VIP. All times are expressed as integer picoseconds.
// ----------------------------------------------------------------------------
package clk_agent_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  typedef enum bit {
    CLK_STOP  = 1'b0,  // clock held low (driver) / clock stopped (monitor)
    CLK_START = 1'b1   // clock toggling with period_ps
  } clk_op_e;

  `include "clk_agent_cfg.svh"
  `include "clk_item.svh"

  typedef uvm_sequencer #(clk_item) clk_sequencer;

  `include "clk_driver.svh"
  `include "clk_monitor.svh"
  `include "clk_agent.svh"
  `include "clk_seq_lib.svh"

endpackage : clk_agent_pkg
