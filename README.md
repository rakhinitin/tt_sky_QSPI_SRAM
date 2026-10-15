![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Tiny Tapeout Verilog Project Template

- [Read the documentation for project](docs/info.md)

## What is Tiny Tapeout?

Tiny Tapeout is an educational project that aims to make it easier and cheaper than ever to get your digital and analog designs manufactured on a real chip.
ARCHITECTURE SCOPE:
##Highlights

Verilog-2001 RTL design using eight modules
Tiny Tapeout standard interface with clk, rst_n, ena, ui_in, uo_out, uio_in, uio_out, and uio_oe
Activity monitoring over a fixed 16-cycle window
Workload classification into low, medium, and high categories
Workload-trend prediction
Finite-state-machine-based power-mode selection
Thermal throttling with hysteresis
Cocotb integration test and gate-level verification
Automated SKY130 physical-design flow using the Tiny Tapeout GitHub Actions workflow
