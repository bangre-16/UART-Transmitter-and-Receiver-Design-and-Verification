`timescale 1ns/1ps

module tb_uart_top;

reg clk;
reg rst;
reg tx_start;
reg [7:0] data_in;

wire tx;
wire tx_done;
wire [7:0] data_out;
wire rx_done;

uart_top uut (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .data_in(data_in),
    .tx(tx),
    .tx_done(tx_done),
    .data_out(data_out),
    .rx_done(rx_done)
);

always #10 clk = ~clk;

initial
begin
    clk = 0;
    rst = 1;
    tx_start = 0;
    data_in = 8'b10110010;

    #50;
    rst = 0;

    #50;
    tx_start = 1;

    #20;
    tx_start = 0;

    #2000000;

    $stop;
end

endmodule