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

## Pinout Configuration

## Complete Pinout Mapping

| Pin Name | Pin Type | Internal Signal Name | Description |
| :--- | :--- | :--- | :--- |
| `clk` | Global Input | `clk` | System clock input |
| `rst_n` | Global Input | `rst_n` | Active-low asynchronous reset |
| `ena` | Global Input | `ena` / `cs` | Active-high chip select / enable |
| `ui_in[0]` | Dedicated Input | `data_in[0]` | Data input bit 0 (nibble LSB) |
| `ui_in[1]` | Dedicated Input | `data_in[1]` | Data input bit 1 |
| `ui_in[2]` | Dedicated Input | `data_in[2]` | Data input bit 2 |
| `ui_in[3]` | Dedicated Input | `data_in[3]` | Data input bit 3 (nibble MSB) |
| `ui_in[4]` | Dedicated Input | `dec_wr_addr[0]` | Write address bit 0 (A0 - LSB) |
| `ui_in[5]` | Dedicated Input | `dec_wr_addr[1]` | Write address bit 1 (A1) |
| `ui_in[6]` | Dedicated Input | `dec_wr_addr[2]` | Write address bit 2 (A2) |
| `ui_in[7]` | Dedicated Input | `dec_wr_addr[3]` | Write address bit 3 (A3) |
| `uo_out[0]` | Dedicated Output | `data_out[0]` | Decrypted parallel data output bit 0 |
| `uo_out[1]` | Dedicated Output | `data_out[1]` | Decrypted parallel data output bit 1 |
| `uo_out[2]` | Dedicated Output | `data_out[2]` | Decrypted parallel data output bit 2 |
| `uo_out[3]` | Dedicated Output | `data_out[3]` | Decrypted parallel data output bit 3 |
| `uo_out[4]` | Dedicated Output | `data_out[4]` | Decrypted parallel data output bit 4 |
| `uo_out[5]` | Dedicated Output | `data_out[5]` | Decrypted parallel data output bit 5 |
| `uo_out[6]` | Dedicated Output | `data_out[6]` | Decrypted parallel data output bit 6 |
| `uo_out[7]` | Dedicated Output | `data_out[7]` | Decrypted parallel data output bit 7 |
| `uio_in[0]` | Bidirectional Input | `dec_wr_addr[4]` | Write address bit 4 (A4 - MSB / boundary check) |
| `uio_in[1]` | Bidirectional Input | `wen` | Write enable strobe (active-high) |
| `uio_in[2]` | Bidirectional Input | `ren` | Read enable strobe (active-high) |
| `uio_in[3]` | Bidirectional Input | `dec_rd_addr[0]` | Read address bit 0 (A0 - LSB) |
| `uio_in[4]` | Bidirectional Input | `dec_rd_addr[1]` | Read address bit 1 (A1) |
| `uio_in[5]` | Bidirectional Input | `dec_rd_addr[2]` | Read address bit 2 (A2) |
| `uio_in[6]` | Bidirectional Input | `dec_rd_addr[3]` | Read address bit 3 (A3) |
| `uio_in[7]` | Bidirectional Input | `dec_rd_addr[4]` | Read address bit 4 (A4 - MSB / boundary check) |
| `uio_out[7:0]`| Bidirectional Output | `uio_out` | Output data bus (internally tied to 8'h00) |
| `uio_oe[7:0]` | Direction Control | `uio_oe` | Bidirectional enable bus (internally tied to 8'h00 to disable outputs) |)"
