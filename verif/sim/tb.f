// MiniSoC AES UVM testbench - paths relative to verif/sim

// Agents
+incdir+../tb/agents/clk_agent
../tb/agents/clk_agent/clk_if.sv
../tb/agents/clk_agent/clk_agent_pkg.sv

+incdir+../tb/agents/rst_agent
../tb/agents/rst_agent/rst_if.sv
../tb/agents/rst_agent/rst_agent_pkg.sv

// Environment, sequences, tests
+incdir+../tb/env
../tb/env/minisoc_env_pkg.sv

+incdir+../tb/sequences
../tb/sequences/minisoc_seq_pkg.sv

+incdir+../tb/tests
../tb/tests/minisoc_test_pkg.sv

// Top
../tb/top_assertions.sv
../tb/top_tb.sv
