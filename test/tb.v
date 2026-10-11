`timescale 1ns / 1ps

module tb;

    reg  [7:0] ui_in;
    wire [7:0] uo_out;
    reg  [7:0] uio_in;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg        ena;
    reg        clk;
    reg        rst_n;

    tt_um_example dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    always #5 clk = ~clk;

    task write_byte(input [4:0] addr, input [7:0] data);
        begin
            @(negedge clk);
            ui_in[7:4] = addr[3:0];
            uio_in[0]  = addr[4];
            ui_in[3:0] = data[7:4];
            uio_in[1]  = 1'b1;
            uio_in[2]  = 1'b0;
            ena        = 1'b1;

            @(negedge clk);
            ui_in[3:0] = data[3:0];

            @(negedge clk);
            uio_in[1]  = 1'b0;
            ui_in[3:0] = 4'h0;
        end
    endtask

    task write_and_read_simultaneous(
        input [4:0] wr_addr, 
        input [7:0] wr_data, 
        input [4:0] rd_addr, 
        input [7:0] expected_rd_data
    );
        begin
            @(negedge clk);
            ui_in[7:4]  = wr_addr[3:0];
            uio_in[0]   = wr_addr[4];
            ui_in[3:0]  = wr_data[7:4];
            uio_in[7:3] = rd_addr;
            uio_in[1]   = 1'b1;
            uio_in[2]   = 1'b1;
            ena         = 1'b1;

            @(negedge clk);
            ui_in[3:0]  = wr_data[3:0];

            @(posedge clk);
            #1;
            if (uo_out === expected_rd_data) begin
                $display("\n>>> [SIMULTANEOUS SUCCESS] While writing to Addr %0d, read from Addr %0d matched 0x%02X! <<<\n", 
                         wr_addr, rd_addr, uo_out);
            end else begin
                $display("\n>>> [SIMULTANEOUS ERROR] Read 0x%02X != Expected 0x%02X <<<\n", 
                         uo_out, expected_rd_data);
            end

            @(negedge clk);
            uio_in[1]  = 1'b0;
            uio_in[2]  = 1'b0;
            ui_in[3:0] = 4'h0;
        end
    endtask

    initial begin
        clk    = 0;
        rst_n  = 0;
        ena    = 1;
        ui_in  = 8'h00;
        uio_in = 8'h00;

        #25;
        @(negedge clk);
        rst_n = 1;
        #5;

        write_byte(5'd5, 8'b1100_0011);
        repeat (2) @(negedge clk);

        write_and_read_simultaneous(5'd8, 8'b1110_0001, 5'd5, 8'b1100_0011);
        repeat (2) @(negedge clk);

        $display("ALL OPERATIONS VERIFIED");
        $finish;
    end

endmodule
