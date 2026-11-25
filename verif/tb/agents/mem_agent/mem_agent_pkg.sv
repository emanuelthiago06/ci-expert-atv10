`timescale 1ps/1ps

// mem_agent_pkg - MEMORY DATA VIP (external memory interface)
package mem_agent_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "mem_agent_cfg.svh"
  `include "mem_item.svh"

  `include "mem_sequencer.svh"

  `include "mem_driver.svh"
  `include "mem_monitor.svh"
  `include "mem_agent.svh"
  `include "mem_seq_lib.svh"

endpackage : mem_agent_pkg
