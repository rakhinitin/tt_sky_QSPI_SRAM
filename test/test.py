# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, FallingEdge, Timer


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start Secure QSPI SRAM Cocotb Testbench")

    # Start 100 MHz clock (10 ns period)
    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    # Initialize signals
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    # Reset sequence
    await Timer(25, unit="ns")
    await FallingEdge(dut.clk)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    # -------------------------------------------------------------------------
    # Helper: Standard 2-Clock Write
    # -------------------------------------------------------------------------
    async def write_byte(addr, data):
        await FallingEdge(dut.clk)
        # Clock 1: Drive MSB nibble and write address
        dut.ui_in.value = ((addr & 0x0F) << 4) | ((data >> 4) & 0x0F)
        dut.uio_in.value = ((addr >> 4) & 0x01) | (1 << 1) | (0 << 2)

        await FallingEdge(dut.clk)
        # Clock 2: Drive LSB nibble to commit
        dut.ui_in.value = ((addr & 0x0F) << 4) | (data & 0x0F)

        await FallingEdge(dut.clk)
        # Clear write enable
        dut.uio_in.value = 0
        dut.ui_in.value = 0

    # -------------------------------------------------------------------------
    # Helper: Simultaneous Write & Read
    # -------------------------------------------------------------------------
    async def write_and_read_simultaneous(wr_addr, wr_data, rd_addr, expected_rd_data):
        await FallingEdge(dut.clk)
        # Clock 1: Setup Write Target MSB, Read Target Address, wen=1, ren=1
        dut.ui_in.value = ((wr_addr & 0x0F) << 4) | ((wr_data >> 4) & 0x0F)
        dut.uio_in.value = (
            ((wr_addr >> 4) & 0x01)
            | (1 << 1)
            | (1 << 2)
            | ((rd_addr & 0x1F) << 3)
        )

        await FallingEdge(dut.clk)
        # Clock 2: Setup Write Target LSB (Readout is latched on this clock edge)
        dut.ui_in.value = ((wr_addr & 0x0F) << 4) | (wr_data & 0x0F)

        await FallingEdge(dut.clk)
        # Sample output on falling edge after read cycle completes
        actual_uo = int(dut.uo_out.value)
        dut._log.info(f"Concurrently read from Addr {rd_addr}: {hex(actual_uo)} (Expected: {hex(expected_rd_data)})")
        assert actual_uo == expected_rd_data, (
            f"Read mismatch: Got {hex(actual_uo)}, Expected {hex(expected_rd_data)}"
        )

        # Clear control enables
        dut.uio_in.value = 0
        dut.ui_in.value = 0

    # STEP 1: Write 0xC3 into Address 5
    dut._log.info("STEP 1: Writing 0xC3 to Address 5")
    await write_byte(5, 0xC3)
    await ClockCycles(dut.clk, 2)

    # STEP 2: Write 0xE1 to Address 8 while concurrently reading Address 5
    dut._log.info("STEP 2: Concurrent Write Addr 8 & Read Addr 5")
    await write_and_read_simultaneous(8, 0xE1, 5, 0xC3)
    await ClockCycles(dut.clk, 2)

    dut._log.info("All Cocotb test sequences passed!")
