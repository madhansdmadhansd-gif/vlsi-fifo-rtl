# VLSI FIFO RTL Starter

A small synthesizable synchronous FIFO written in SystemVerilog. It is a practical starting point for RTL design and synthesis experiments.

## Features

- Parameterized data width and depth
- Active-low asynchronous reset for control state
- Full and empty flags
- Simultaneous read and write support
- Explicit pointer wrap, including non-power-of-two depths
- Yosys synthesis script and a generic SDC timing-constraint example

The memory contents are not reset. rd_data is a combinational read from the current head entry; consumers should use it only when empty is low.

## Interface

| Signal | Direction | Description |
| --- | --- | --- |
| clk | input | FIFO clock |
| rst_n | input | Active-low reset |
| wr_en | input | Request a write |
| wr_data | input | Data to write |
| rd_en | input | Request a read |
| rd_data | output | Data at the current read pointer |
| full | output | FIFO cannot accept a write unless a read also occurs |
| empty | output | FIFO contains no entries |

A write while full is ignored unless a valid read happens in the same cycle. A read while empty is ignored. When read and write are both accepted, occupancy stays constant.

## Synthesis

Install Yosys and GNU Make, then run:

    make synth

The script synthesizes fifo_top and writes build/fifo_top.json. The SDC file is a starting example; adjust clock and IO delays for the target device and board before using it for timing signoff.

## Parameters

The example top uses DATA_WIDTH=16 and DEPTH=16. The module supports any positive depth. Small FIFOs may map to registers; deeper memories may need a target-specific RAM inference style.

## Files

- rtl/sync_fifo.sv — parameterized FIFO.
- examples/fifo_top.sv — synthesizable example top.
- constraints/timing.sdc — generic timing constraints.
- scripts/synth.ys — Yosys synthesis flow.

## License

MIT
