// ----------------------------------------------------------------------------
// rst_if
//
// Active-low asynchronous reset. The driver initializes rst_n to 1 at time 0
// and every reset is an explicit 1->0 transition: the SPI SCLK-domain flops
// use an asynchronous reset and are only cleared by a real negedge of rst_n.
// ----------------------------------------------------------------------------
interface rst_if;
  logic rst_n;
endinterface : rst_if
