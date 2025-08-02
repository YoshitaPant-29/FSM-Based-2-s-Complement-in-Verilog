# FSM-Based-2-s-Complement-in-Verilog

1.Introduction
In digital systems, 2’s complement is a standard method for representing negative numbers. Traditionally, it is computed by inverting all bits of the number and adding 1. However, in this project, we explore an alternative approach — using a Finite State Machine (FSM) to generate the 2’s complement bit-by-bit. This method is slower than the conventional approach but provides an educational perspective on sequential logic design and bit-level operations.

2.Design Logic
The FSM is designed to compute the 2’s complement using the following sequence:
Step 1: Start from the Least Significant Bit (LSB).
Step 2: Copy bits exactly as they are until the first ‘1’ is found.
Step 3: Once the first ‘1’ is encountered, invert all remaining higher-order bits.

This sequence is implemented as simple state transitions in Verilog with the following states:
IDLE – Wait for the start signal.
COPY – Copy bits as-is until the first ‘1’ is detected.
INVERT – Invert all remaining bits.
FINISH – Assert done and hold the result.

3. Implementation
The Verilog code is structured with:
•design.v: Main FSM module implementing the sequential 2’s complement algorithm.
•Testbench.v to verify functionality through simulation.

4. Simulation Methodology
4.1 Behavioral Simulation
The testbench checks if the FSM correctly produces the 2’s complement for various input
patterns. The simulation traces show state transitions (IDLE → COPY → INVERT →
FINISH) and verify that the output matches the expected bitwise 2’s complement. 

4.2 Post-Synthesis Functional Simulation
The Verilog code is synthesized into a gate-level netlist and simulated without delays to
confirm that logical correctness is preserved after synthesis. The outputs are identical to
the behavioral simulation. 

4.3 Post-Synthesis Timing Simulation
In this simulation, the synthesized netlist includes delays from logic gates, wires, and
flip-flops. The results confirm correct operation with a slight timing shift representing
real-world hardware delay effects.
