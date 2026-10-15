![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Tiny Tapeout Verilog Project Template

- [Read the documentation for project](docs/info.md)


## architecture:
<img width="1622" height="647" alt="Screenshot 2026-10-13 at 2 19 59 PM" src="https://github.com/user-attachments/assets/0f5bb836-5aca-4b18-ad19-cebb52a1c873" />

## flowchart:
<img width="767" height="789" alt="Screenshot 2026-10-13 at 2 23 13 PM" src="https://github.com/user-attachments/assets/176a650a-983b-464f-9fa6-8435b29d0f4c" />

## Repository structure:

power_governer_tiny_tapeout/
├── .github/workflows/   # Automated test and GDS workflows
├── docs/
│   └── info.md          # Tiny Tapeout project documentation
├── src/
│   └── project.v        # Top wrapper and PwrGov-X RTL modules
├── test/
│   ├── Makefile         # Cocotb simulation configuration
│   ├── tb.v             # Tiny Tapeout test harness
│   └── test.py          # Cocotb integration test
├── info.yaml            # Project metadata and pin descriptions
└── README.md            # Project overview and technical documentation

