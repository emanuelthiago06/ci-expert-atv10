`timescale 1ps/1ps

// ----------------------------------------------------------------------------
// minisoc_seq_pkg - virtual sequences
// ----------------------------------------------------------------------------
package minisoc_seq_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import clk_agent_pkg::*;
  import rst_agent_pkg::*;
  import minisoc_env_pkg::*;

  `include "minisoc_base_vseq.svh"
  `include "minisoc_smoke_vseq.svh"

endpackage : minisoc_seq_pkg
