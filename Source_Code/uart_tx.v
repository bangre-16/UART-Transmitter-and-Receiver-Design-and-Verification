module uart_tx(
    input clk,
    input rst,
    input tx_start,
    input baud_tick,
    input [7:0] data_in,
    output reg tx,
    output reg tx_done
);

reg [1:0] state;
reg [7:0] shift_reg;
reg [2:0] bit_count;

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state <= IDLE;
        tx <= 1'b1;
        tx_done <= 1'b0;
        shift_reg <= 8'b0;
        bit_count <= 3'b0;
    end
    else
    begin
        case(state)

        IDLE:
        begin
            tx <= 1'b1;
            tx_done <= 1'b0;

            if(tx_start)
            begin
                shift_reg <= data_in;
                bit_count <= 3'b0;
                state <= START;
            end
        end

        START:
        begin
            if(baud_tick)
            begin
                tx <= 1'b0;
                state <= DATA;
            end
        end

        DATA:
        begin
            if(baud_tick)
            begin
                tx <= shift_reg[0];
                shift_reg <= shift_reg >> 1;

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
                tx <= 1'b1;
                tx_done <= 1'b1;
                state <= IDLE;
            end
        end

        endcase
    end
end

endmodule