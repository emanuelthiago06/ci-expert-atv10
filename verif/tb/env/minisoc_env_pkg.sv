`timescale 1ps/1ps

// ----------------------------------------------------------------------------
// minisoc_env_pkg
//
// Top-level environment for the MiniSoC AES (Oct/2026 baseline):
//   ref clk (active), mem_clk (active), sys_clk (passive probe), reset (active)
// ----------------------------------------------------------------------------
package minisoc_env_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import clk_agent_pkg::*;
  import rst_agent_pkg::*;

  `include "minisoc_env_cfg.svh"
  `include "minisoc_vsequencer.svh"
  `include "minisoc_env.svh"

endpackage : minisoc_env_pkg
