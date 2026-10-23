.PHONY: synth clean

synth:
	mkdir -p build
	yosys -s scripts/synth.ys

clean:
	rm -rf build
