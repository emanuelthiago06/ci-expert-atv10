// ----------------------------------------------------------------------------
// clk_if
//
// Single clock wire. Used in two ways:
//   - ACTIVE : the clk_driver generates the clock (clk, mem_clk).
//   - PASSIVE: the wire is connected to a DUT clock (sys_clk) and only the
//              clk_monitor runs, measuring start/stop/period.
// ----------------------------------------------------------------------------
interface clk_if;
  logic clk;
endinterface : clk_if
