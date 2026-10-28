`timescale 1ps/1ps

// ----------------------------------------------------------------------------
// minisoc_test_pkg
// ----------------------------------------------------------------------------
package minisoc_test_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import clk_agent_pkg::*;
  import rst_agent_pkg::*;
  import minisoc_env_pkg::*;
  import minisoc_seq_pkg::*;

  `include "minisoc_base_test.svh"
  `include "minisoc_smoke_test.svh"

endpackage : minisoc_test_pkg
