`timescale 1ns / 1ps

module tb_twos_comp_clean;
    reg        clk;
    reg        rst;
    reg        incode;
    wire       outcode;
    wire       seen_one;

    // Instantiate DUT (assumes module name is twos_comp with seen_one output)
    twos_comp dut (
        .clk(clk),
        .rst(rst),
        .incode(incode),
        .outcode(outcode),
        .seen_one(seen_one)
    );

    // Test variables
    reg [7:0] input_value;
    reg [7:0] output_value;
    reg [7:0] expected;
    integer i;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period
    end

    // Initial reset and defaults to avoid Xs
    initial begin
        // Initialize everything
        input_value  = 8'd0;
        output_value = 8'd0;
        incode       = 1'b0;
        rst          = 1'b1;

        // Waveform dump
        $dumpfile("twos_comp_clean.vcd");
        $dumpvars(0, tb_twos_comp_clean);

        // Hold reset for a few cycles
        #15;
        rst = 1'b0; // release reset
        #10;

        // Choose a test input: 8'b00000101 (5)
        input_value = 8'b00000101;
        expected = ((~input_value) + 1) & 8'hFF; // 8-bit 2's complement

        $display("\nFeeding bits LSB first. Input = %b, expected 2's complement = %b", input_value, expected);

        // Feed serial bits LSB first
        for (i = 0; i < 8; i = i + 1) begin
            incode = input_value[i];
            #10; // wait one clock cycle
            output_value[i] = outcode; // capture corresponding output bit
            $display("Cycle %0d: in=%b out=%b seen_one=%b", i, incode, outcode, seen_one);
        end

        #10;
        $display("\nFinal serial output (LSB first): %b", output_value);
        $display("Expected 2's complement:          %b", expected);
        if (output_value == expected)
            $display("RESULT: PASS");
        else
            $display("RESULT: FAIL");

        #20;
        $finish;
    end
endmodule
