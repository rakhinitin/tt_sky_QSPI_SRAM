![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Tiny Tapeout Verilog Project Template

- [Read the documentation for project](docs/info.md)


## architecture:
<img width="1622" height="647" alt="Screenshot 2026-10-13 at 2 19 59 PM" src="https://github.com/user-attachments/assets/0f5bb836-5aca-4b18-ad19-cebb52a1c873" />

## flowchart:
<img width="767" height="789" alt="Screenshot 2026-10-13 at 2 23 13 PM" src="https://github.com/user-attachments/assets/176a650a-983b-464f-9fa6-8435b29d0f4c" />

## Repository structure:

```text
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
```
## Documentation
documentation: 
  author:       "Sahil Sexsena"
  title:        "Secure QSPI SRAM Module"
  language:     "Verilog"
  description:  "128-bit QSPI SRAM with on-chip 8-bit XOR cipher, dual 5:32 decoders, and a 128-pin joint matrix"

## Pinout mapping for Tiny Tapeout datasheet and viewer
pinout:
  ## Dedicated Inputs (ui_in)
  ui[0]: "data_in[0] (nibble LSB)"
  ui[1]: "data_in[1]"
  ui[2]: "data_in[2]"
  ui[3]: "data_in[3] (nibble MSB)"
  ui[4]: "dec_wr_addr[0] (A0 - LSB)"
  ui[5]: "dec_wr_addr[1] (A1)"
  ui[6]: "dec_wr_addr[2] (A2)"
  ui[7]: "dec_wr_addr[3] (A3)"

  ## Dedicated Outputs (uo_out)
  uo[0]: data_out[0]
  
  uo[1]: data_out[1]
  
  uo[2]: data_out[2]
  
  uo[3]: data_out[3]
  
  uo[4]: data_out[4]
  
  uo[5]: data_out[5]
  
  uo[6]: data_out[6]
  
  uo[7]: data_out[7]

  ## Bidirectional IOs configured as inputs (uio_in)
  uio[0]: "dec_wr_addr[4] (A4 - MSB)"
  uio[1]: "wen (Write Enable, active-high)"
  uio[2]: "ren (Read Enable, active-high)"
  uio[3]: "dec_rd_addr[0] (A0 - LSB)"
  uio[4]: "dec_rd_addr[1] (A1)"
  uio[5]: "dec_rd_addr[2] (A2)"
  uio[6]: "dec_rd_addr[3] (A3)"
  uio[7]: "dec_rd_addr[4] (A4 - MSB)"
