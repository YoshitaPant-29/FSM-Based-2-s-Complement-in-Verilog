module twos_comp (
    input  wire clk,
    input  wire rst,      // active-high async reset
    input  wire incode,   // serial input bit (LSB first)
    output reg  outcode,  // serial output bit
    output reg  seen_one  // optional: flag when first '1' has been seen
);

    // States
    localparam Copy   = 1'b0;
    localparam Invert = 1'b1;

    reg state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            outcode  <= 1'b0;
            state    <= Copy;
            seen_one <= 1'b0;
        end else begin
            case (state)
                Copy: begin
                    outcode <= incode;
                    if (incode == 1'b1) begin
                        state    <= Invert;
                        seen_one <= 1'b1;
                    end
                end
                Invert: begin
                    outcode <= ~incode;
                    seen_one <= 1'b1;
                end
                default: state <= Copy;
            endcase
        end
    end

endmodule
