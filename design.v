// Code your design here
module fsm_2scomp_simple (
    input        clk,
    input        reset,   // active-high async reset
    input        start,   // pulse to begin
    input  [7:0] in,      // input number
    output reg [7:0] out, // 2's complement
    output reg   done     // result ready
);

    // States
    parameter IDLE   = 2'b00;
    parameter COPY   = 2'b01;
    parameter INVERT = 2'b10;
    parameter FINISH = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] bit_pos; // up to 7
    reg seen_one;

    // Sequential updates
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state    <= IDLE;
            out      <= 8'd0;
            done     <= 0;
            bit_pos  <= 0;
            seen_one <= 0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    done     <= 0;
                    bit_pos  <= 0;
                    seen_one <= 0;
                    out      <= 8'd0;
                end

                COPY: begin
                    out[bit_pos] <= in[bit_pos];
                    if (in[bit_pos] == 1'b1)
                        seen_one <= 1;
                    bit_pos <= bit_pos + 1;
                end

                INVERT: begin
                    out[bit_pos] <= ~in[bit_pos];
                    bit_pos <= bit_pos + 1;
                end

                FINISH: begin
                    done <= 1;
                    // hold out
                end
            endcase
        end
    end

    // Next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (start)
                    next_state = COPY;
            end

            COPY: begin
                if (bit_pos == 4'd8) // finished all bits without needing invert
                    next_state = FINISH;
                else if (seen_one) begin
                    if (bit_pos == 4'd8)
                        next_state = FINISH;
                    else
                        next_state = INVERT;
                end else begin
                    if (bit_pos == 4'd8)
                        next_state = FINISH;
                    else
                        next_state = COPY;
                end
            end

            INVERT: begin
                if (bit_pos == 4'd8)
                    next_state = FINISH;
                else
                    next_state = INVERT;
            end

            FINISH: begin
                if (!start)
                    next_state = IDLE;
            end
        endcase
    end

endmodule
