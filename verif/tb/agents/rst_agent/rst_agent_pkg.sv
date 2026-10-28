`timescale 1ps/1ps

// ----------------------------------------------------------------------------
// rst_agent_pkg
//
// Reset VIP. All times are expressed as integer picoseconds.
// ----------------------------------------------------------------------------
package rst_agent_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  typedef enum bit {
    RST_ASSERT   = 1'b0,
    RST_DEASSERT = 1'b1
  } rst_evt_e;

  `include "rst_agent_cfg.svh"
  `include "rst_item.svh"

  typedef uvm_sequencer #(rst_item) rst_sequencer;

  `include "rst_driver.svh"
  `include "rst_monitor.svh"
  `include "rst_agent.svh"
  `include "rst_seq_lib.svh"

endpackage : rst_agent_pkg
