// ----------------------------------------------------------------------------
// spi_if
//
// SPI Mode 0 (CPOL=0, CPHA=0). The agent acts as the SPI master: it drives
// sclk, cs_n and mosi; miso is driven by the DUT.
//
// Idle state (set by the driver at time 0): sclk=0, cs_n=1, mosi=0.
// ----------------------------------------------------------------------------
interface spi_if;
  logic sclk;
  logic cs_n;
  logic mosi;
  logic miso;
endinterface : spi_if
