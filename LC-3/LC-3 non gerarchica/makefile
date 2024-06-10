VERILOG_SOURCES = design.sv testbench.sv
OUTPUT = LC_3

all: $(OUTPUT) run

$(OUTPUT): $(VERILOG_SOURCES)
	iverilog -o $(OUTPUT) $(VERILOG_SOURCES)

.PHONY: run

run: $(OUTPUT)
	export PATH=$$PATH:/path/to/iverilog:/path/to/vvp
	vvp $(OUTPUT)
	rm -f $(OUTPUT)
