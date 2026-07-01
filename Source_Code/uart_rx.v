module uart_rx(
    input clk,
    input rst,
    input baud_tick,
    input rx,

    output reg [7:0] data_out,
    output reg rx_done
);

reg [1:0] state;
reg [2:0] bit_count;
reg [7:0] shift_reg;

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state <= IDLE;
        bit_count <= 3'd0;
        shift_reg <= 8'd0;
        data_out <= 8'd0;
        rx_done <= 1'b0;
    end

    else
    begin
        case(state)

            IDLE:
            begin
                rx_done <= 1'b0;

                if(rx == 1'b0)
                    state <= START;
            end

            START:
            begin
                if(baud_tick)
                begin
                    bit_count <= 3'd0;
                    state <= DATA;
                end
            end

            DATA:
            begin
                if(baud_tick)
                begin
                    shift_reg[bit_count] <= rx;

                    if(bit_count == 3'd7)
                        state <= STOP;
                    else
                        bit_count <= bit_count + 1'b1;
                end
            end

            STOP:
            begin
                if(baud_tick)
                begin
                    data_out <= shift_reg;
                    rx_done <= 1'b1;
                    state <= IDLE;
                end
            end

        endcase
    end
end

endmodule