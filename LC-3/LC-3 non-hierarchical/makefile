Componenti = ./Componenti/design.sv ./Componenti/testbench.sv
Output = LC_3

all: $(Output) run

$(Output): $(Componenti)
	iverilog -o $(Output) $(Componenti)

.PHONY: run

run: $(Output)
	export PATH=$$PATH:/path/to/iverilog:/path/to/vvp
	vvp $(Output)
	rm -f $(Output)
	mv dump.vcd ./Output
	