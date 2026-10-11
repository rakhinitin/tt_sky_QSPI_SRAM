/*
 * Copyright (c) 2026 Sahil Sexsena
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // [3:0]=data_in, [7:4]=wr_addr[3:0]
    output reg  [7:0] uo_out,   // [7:0]=8-bit parallel decrypted output
    input  wire [7:0] uio_in,   // [0]=wr_addr[4], [1]=wen, [2]=ren, [7:3]=rd_sel[4:0]
    output wire [7:0] uio_out,  // Tied to 0
    output wire [7:0] uio_oe,   // Direction control: 0 = all inputs
    input  wire       ena,      // Chip Select (cs) - active-high
    input  wire       clk,      // System clock
    input  wire       rst_n     // Reset - active-low
);

    // Fixed 8-Bit Secret Key for Parallel XOR Encryption & Decryption
    localparam [7:0] CIPHER_KEY = 8'b1010_1010; // 0xAA

    // ----------------------------------------------------------------
    // 1. Signal Mapping
    // ----------------------------------------------------------------
    wire       rst     = ~rst_n;
    wire       cs      = ena;
    wire [3:0] io_in   = ui_in[3:0];
    wire [4:0] wr_addr = {uio_in[0], ui_in[7:4]};  // {A4, A3, A2, A1, A0}
    wire       wen     = uio_in[1];
    wire       ren     = uio_in[2];
    wire [4:0] rd_sel  = uio_in[7:3];

    assign uio_out = 8'h00;
    assign uio_oe  = 8'h00;

    // ----------------------------------------------------------------
    // 2. Physical 256-Bit Memory Array (32 Bytes x 8 Bits)
    // ----------------------------------------------------------------
    reg [3:0]   msb_buf;
    reg         nibble_phase;
    reg [255:0] mem_cells;

    // ----------------------------------------------------------------
    // 3. Write Datapath: 5:32 Decoder & Wordline Qualification
    // ----------------------------------------------------------------
    wire [31:0] wr_wordline = (cs && wen) ? (32'b1 << wr_addr) : 32'b0;
    wire        addr_ready_flag = |wr_wordline;

    // ----------------------------------------------------------------
    // 4. Read Datapath: 5:32 Decoder & 256-to-8 Bitline Gating Matrix
    // ----------------------------------------------------------------
    wire [31:0] rd_wordline = (cs && ren) ? (32'b1 << rd_sel) : 32'b0;

    // Shared 8-bit read bitline: OR-reduction across all 32 slices
    reg [7:0] rd_bitline;
    integer b;
    always @(*) begin
        rd_bitline = 8'h00;
        for (b = 0; b < 32; b = b + 1) begin
            if (rd_wordline[b]) begin
                rd_bitline = rd_bitline | mem_cells[b*8 +: 8];
            end
        end
    end

    // ----------------------------------------------------------------
    // 5. Synchronous Sequential Execution
    // ----------------------------------------------------------------
    integer w_idx;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            msb_buf      <= 4'b0000;
            nibble_phase <= 1'b0;
            uo_out       <= 8'h00;
            mem_cells    <= 256'b0;
        end else if (!cs) begin
            nibble_phase <= 1'b0;
            uo_out       <= 8'h00;
        end else begin
            // --- Write Path: 2 Consecutive Clocks ---
            if (!wen) begin
                nibble_phase <= 1'b0;
            end else begin
                if (!nibble_phase) begin
                    // Clock 1: Latch 4-bit MSB into msb_buf
                    msb_buf      <= io_in;
                    nibble_phase <= 1'b1;
                end else begin
                    // Clock 2: Commit assembled byte {msb_buf, io_in} ^ 0xAA
                    nibble_phase <= 1'b0;
                    if (addr_ready_flag) begin
                        for (w_idx = 0; w_idx < 32; w_idx = w_idx + 1) begin
                            if (wr_wordline[w_idx]) begin
                                mem_cells[w_idx*8 +: 8] <= {msb_buf, io_in} ^ CIPHER_KEY;
                            end
                        end
                    end
                end
            end

            // --- Read Path: 1-Clock Parallel Decrypted Readout ---
            if (!ren) begin
                uo_out <= 8'h00;
            end else begin
                uo_out <= rd_bitline ^ CIPHER_KEY;
            end
        end
    end

endmodule
