![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

## Secure QSPI SRAM: Hardware-Encrypted Memory 
A parameter-conscious, secure digital SRAM IP implemented in Verilog for Tiny Tapeout using the SkyWater SKY130 ASIC design flow. The core integrates an on-chip symmetric 8-bit parallel XOR cipher pipeline, dual 5:32 address decoders, and a direct 128-pin joint connection matrix that eliminates multiplexer trees to achieve single-cycle reads, two-cycle writes, and simultaneous dual-port memory access within a single 1x1 tile.

## Highlights
* Parameter-conscious Verilog RTL implementation targeting a Tiny Tapeout 1x1 tile footprint
* Standard Tiny Tapeout pad interface using clk, rst_n, ena, ui_in, uo_out, uio_in, uio_out, and uio_oe
* Physical 128-bit memory core organized as 16 addressable bytes by 8 bits
* Symmetric on-chip 8-bit parallel XOR encryption and decryption engine using fixed secret key 0xAA (8'b1010_1010)
* Pure decoder-driven memory gating via dual 5:32 write and read decoders without multiplexer trees
* Direct 128-pin joint connection matrix bridging decoders directly to flip-flop storage cells
* Deterministic timing: two-cycle sequential write operations and single-cycle parallel read operations
* Non-interfering simultaneous access supporting concurrent write and read operations
* Hardware address qualification and out-of-bounds protection with architectural pin reservation for 32-byte expansion
* Cocotb testbench and Gate-Level (gl_test) simulation verification
* Automated GDSII physical implementation flow via Tiny Tapeout GitHub Actions

## Architecture:
<img width="1622" height="647" alt="Screenshot 2026-10-13 at 2 19 59 PM" src="https://github.com/user-attachments/assets/0f5bb836-5aca-4b18-ad19-cebb52a1c873" />

## Functional Flow:
<img width="767" height="789" alt="Screenshot 2026-10-13 at 2 23 13 PM" src="https://github.com/user-attachments/assets/176a650a-983b-464f-9fa6-8435b29d0f4c" />

## Operating Modes

| Mode Name | Trigger Condition | Hardware State | Description |
| :--- | :--- | :--- | :--- |
| `Reset / Clear` | `!rst_n` | State Reset | Initialize |
| `Standby` | `!cs` or (`!wen` and `!ren`) | `s_standby` | Retention |
| `Write Ingestion` | `cs && wen && !nibble_phase` | `WRITE_MSB` | Buffering |
| `Write Commit` | `addr_ready_flag && nibble_phase` | `WRITE_COMMIT` | Encryption |
| `Parallel Read` | `cs && ren` | `PARALLEL READ` | Decryption |
| `Simultaneous Access` | `cs && wen && ren` | Dual-Port Active | Concurrent |

## Tiny Tapeout Interface
The top level module is tt_um_example
## Pinout Configuration

### Global Control Pins
| Pin Name | Pin Type | Internal Signal Name | Description |
| :--- | :--- | :--- | :--- |
| `clk` | Global Input | `clk` | System clock input |
| `rst_n` | Global Input | `rst_n` | Active-low asynchronous reset |
| `ena` | Global Input | `ena` / `cs` | Active-high chip select / enable |

## Dedicated Inputs (`ui_in`)
| Pin Name | Pin Type | Internal Signal Name | Description |
| :--- | :--- | :--- | :--- |
| `ui_in[0]` | Dedicated Input | `data_in[0]` | Data input bit 0 (nibble LSB) |
| `ui_in[1]` | Dedicated Input | `data_in[1]` | Data input bit 1 |
| `ui_in[2]` | Dedicated Input | `data_in[2]` | Data input bit 2 |
| `ui_in[3]` | Dedicated Input | `data_in[3]` | Data input bit 3 (nibble MSB) |
| `ui_in[4]` | Dedicated Input | `dec_wr_addr[0]` | Write address bit 0 (A0 - LSB) |
| `ui_in[5]` | Dedicated Input | `dec_wr_addr[1]` | Write address bit 1 (A1) |
| `ui_in[6]` | Dedicated Input | `dec_wr_addr[2]` | Write address bit 2 (A2) |
| `ui_in[7]` | Dedicated Input | `dec_wr_addr[3]` | Write address bit 3 (A3) |

## Dedicated Outputs (`uo_out`)
| Pin Name | Pin Type | Internal Signal Name | Description |
| :--- | :--- | :--- | :--- |
| `uo_out[0]` | Dedicated Output | `data_out[0]` | Decrypted parallel data output bit 0 |
| `uo_out[1]` | Dedicated Output | `data_out[1]` | Decrypted parallel data output bit 1 |
| `uo_out[2]` | Dedicated Output | `data_out[2]` | Decrypted parallel data output bit 2 |
| `uo_out[3]` | Dedicated Output | `data_out[3]` | Decrypted parallel data output bit 3 |
| `uo_out[4]` | Dedicated Output | `data_out[4]` | Decrypted parallel data output bit 4 |
| `uo_out[5]` | Dedicated Output | `data_out[5]` | Decrypted parallel data output bit 5 |
| `uo_out[6]` | Dedicated Output | `data_out[6]` | Decrypted parallel data output bit 6 |
| `uo_out[7]` | Dedicated Output | `data_out[7]` | Decrypted parallel data output bit 7 |

## Bidirectional IO Pins (`uio`)
| Pin Name | Direction Mode | Internal Signal Name | Description |
| :--- | :--- | :--- | :--- |
| `uio_in[0]` | Input | `dec_wr_addr[4]` | Write address bit 4 (A4 - MSB / boundary check) |
| `uio_in[1]` | Input | `wen` | Write enable strobe (active-high) |
| `uio_in[2]` | Input | `ren` | Read enable strobe (active-high) |
| `uio_in[3]` | Input | `dec_rd_addr[0]` | Read address bit 0 (A0 - LSB) |
| `uio_in[4]` | Input | `dec_rd_addr[1]` | Read address bit 1 (A1) |
| `uio_in[5]` | Input | `dec_rd_addr[2]` | Read address bit 2 (A2) |
| `uio_in[6]` | Input | `dec_rd_addr[3]` | Read address bit 3 (A3) |
| `uio_in[7]` | Input | `dec_rd_addr[4]` | Read address bit 4 (A4 - MSB / boundary check) |
| `uio_out[7:0]` | Output (Tied) | `uio_out` | Internally tied to `8'h00` |
| `uio_oe[7:0]` | Control (Tied) | `uio_oe` | Internally tied to `8'h00` (configures bidirectional pads as inputs) |

## Verification
The design completed the full automated Tiny Tapeout verification suite, passing all functional simulations and post-synthesis checks.

The successful GitHub Actions workflow reports the following job results:

| Check | Result |
| :--- | :--- |
| GDS generation | Passed |
| Tiny Tapeout precheck | Passed |
| Gate-level test (`gl_test`) | Passed |
| Viewer deployment | Passed |

---

## Physical Design
Physical implementation was completed using the SkyWater SKY130 (130nm) open-source ASIC flow targeted for a standard Tiny Tapeout 1x1 tile. The pure decoder-driven architecture and 128-pin joint matrix maintain balanced cell density and routability across standard metal layers without routing congestion.

The automated GDS workflow reported the following routing statistics:

| Metric | Recorded Result |
| :--- | :--- |
| Core Utilisation | 45.347 % |
| Wire Length | 19,562 µm |
| GDS Generation | Successful |

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
## Team Members
* Sahil Sexsena $\rightarrow$ [GitHub](https://github.com/sahilatr)
* Varalakshmi S Kulal $\rightarrow$ 
* Shobhit Jaiswal $\rightarrow$ [GitHub](https://github.com/shobhitjaiswal7777)
* Soumayarani $\rightarrow$
 
## Acknowledgements

Built using the Tiny Tapeout Verilog project template, the SkyWater SKY130 process design kit, Cocotb, and the automated Tiny Tapeout physical-design workflow.

* Tiny Tapeout: https://tinytapeout.com/
* Author: [Sahil](https://github.com/sahilatr)
* Repository: https://github.com/sahilatr/tt_sky_QSPI_SRAM
