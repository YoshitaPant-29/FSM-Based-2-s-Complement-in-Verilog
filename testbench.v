// Code your testbench here
// or browse Examples
`timescale 1ns/1ps
module tb_fsm_2scomp_simple;
    reg        clk;
    reg        reset;
    reg        start;
    reg [7:0]  in;
    wire [7:0] out;
    wire       done;

    fsm_2scomp_simple dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .in(in),
        .out(out),
        .done(done)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("fsm2s_simple.vcd");
        $dumpvars(0, tb_fsm_2scomp_simple);

        // reset
        reset = 1; start = 0; in = 8'h00;
        #12;
        reset = 0;

        // test vector: 0 -> 0
        in = 8'h00; start = 1; #10; start = 0;
        wait (done);
        $display("in=0x%0h out=0x%0h", in, out);

        #20;
        // test: 5 -> -5 = 0xFB
        in = 8'h05; start = 1; #10; start = 0;
        wait (done);
        $display("in=0x%0h out=0x%0h", in, out);

        #20;
        // test: 1 -> 0xFF
        in = 8'h01; start = 1; #10; start = 0;
        wait (done);
        $display("in=0x%0h out=0x%0h", in, out);

        #20;
        // test: 0x80 -> 0x80
        in = 8'h80; start = 1; #10; start = 0;
        wait (done);
        $display("in=0x%0h out=0x%0h", in, out);

        #30;
        $finish;
    end
endmodule
