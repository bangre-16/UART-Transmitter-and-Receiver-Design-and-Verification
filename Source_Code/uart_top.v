module uart_top(
    input clk,
    input rst,
    input tx_start,
    input [7:0] data_in,

    output tx,
    output tx_done,

    output [7:0] data_out,
    output rx_done
);

wire baud_tick;
wire rx;

assign rx = tx;

baud_gen BG (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick)
);

uart_tx TX (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .baud_tick(baud_tick),
    .data_in(data_in),
    .tx(tx),
    .tx_done(tx_done)
);

uart_rx RX (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .rx(rx),
    .data_out(data_out),
    .rx_done(rx_done)
);

endmodule