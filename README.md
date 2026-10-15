![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Tiny Tapeout Verilog Project Template

- [Read the documentation for project](docs/info.md)


## architecture:
<img width="1622" height="647" alt="Screenshot 2026-10-13 at 2 19 59 PM" src="https://github.com/user-attachments/assets/0f5bb836-5aca-4b18-ad19-cebb52a1c873" />

## flowchart:
<img width="767" height="789" alt="Screenshot 2026-10-13 at 2 23 13 PM" src="https://github.com/user-attachments/assets/176a650a-983b-464f-9fa6-8435b29d0f4c" />

## Repository structure:

tt_sky_QSPI_SRAM/
├── .github/workflows/   # Automated CI/CD simulation and GDS workflows
├── docs/
│   └── info.md          # Tiny Tapeout project documentation and pinout
├── src/
│   └── project.v        # Secure QSPI SRAM top-level RTL implementation
├── test/
│   ├── Makefile         # Cocotb and Icarus Verilog simulation configuration
│   ├── tb.v             # Clean Tiny Tapeout top-level test wrapper
│   └── test.py          # Synchronous Cocotb verification test suite
├── info.yaml            # Tiny Tapeout project metadata and pin descriptions
└── README.md            # Technical architecture manual and test guide
