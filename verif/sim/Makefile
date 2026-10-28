# -----------------------------------------------------------------------------
# MiniSoC AES - UVM verification environment (Synopsys VCS)
#
#   make compile                         compile/elaborate (simv)
#   make sim TEST=<test> SEED=<n>        run one test
#   make sim TEST=<test> WAVES=1         run with FSDB dump (Verdi)
#   make gui TEST=<test>                 run under Verdi/DVE interactive
#   make clean
#
# Run from verif/sim.
# -----------------------------------------------------------------------------

TEST      ?= minisoc_smoke_test
SEED      ?= 1
VERB      ?= UVM_MEDIUM
WAVES     ?= 0
SIM_ARGS  ?=
VCS_ARGS  ?=

LOG_DIR   := logs
SIMV      := ./simv

VCS_FLAGS := -full64 -sverilog -ntb_opts uvm-1.2 -timescale=1ns/1ps \
             -kdb -debug_access+all +lint=TFIPC-L \
             -assert svaext \
             -f rtl.f -f tb.f -top tb_top -o $(SIMV)

ifeq ($(WAVES),1)
  VCS_FLAGS += +define+WAVES_FSDB
endif

RUN_FLAGS = +UVM_TESTNAME=$(TEST) +ntb_random_seed=$(SEED) +UVM_VERBOSITY=$(VERB) $(SIM_ARGS)

.PHONY: compile sim gui clean help

help:
	@sed -n '2,10p' Makefile

compile:
	@mkdir -p $(LOG_DIR)
	vcs $(VCS_FLAGS) $(VCS_ARGS) -l $(LOG_DIR)/compile.log

sim: $(SIMV)
	@mkdir -p $(LOG_DIR)
	$(SIMV) $(RUN_FLAGS) -l $(LOG_DIR)/$(TEST)_$(SEED).log
	@grep -q "TEST PASSED" $(LOG_DIR)/$(TEST)_$(SEED).log

gui: $(SIMV)
	$(SIMV) $(RUN_FLAGS) -gui -l $(LOG_DIR)/$(TEST)_$(SEED)_gui.log

$(SIMV):
	$(MAKE) compile

clean:
	rm -rf csrc simv simv.daidir ucli.key vc_hdrs.h *.fsdb *.vpd verdiLog novas.* \
	       $(LOG_DIR) AN.DB DVEfiles
