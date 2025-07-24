
# LC-3 Processor Implementation in Verilog

## Overview

This project is a Verilog/SystemVerilog implementation of the LC-3 (Little Computer 3) processor. It was developed as part of an academic project at the University of Verona. The project demonstrates how a basic processor, based on the LC-3 architecture, can be built from scratch using digital design concepts.

## Features

- **Finite State Machine (FSM)**: Manages control signals and the fetch-decode-execute cycle.
- **Arithmetic Logic Unit (ALU)**: Performs arithmetic and logical operations.
- **Registers and Memory**: Implements general-purpose registers and RAM for storage.
- **Sign Extension and Multiplexers**: Extends and manages data flow between components.
- **Testbench**: Includes a testbench for simulating the processor and verifying functionality.

## Files

- `FSM.sv`: Controls the main operation of the processor.
- `ALU.sv`: Performs arithmetic and logic operations.
- `design.sv`: Main design file, integrates all components.
- `RegFile.sv`: Implements the general-purpose registers.
- `Ram.sv`: Provides memory storage.
- Additional modules for multiplexers, sign extension, and I/O.

## Instructions

To run the LC-3 processor:

1. **Load the Program**: Input the binary program into RAM starting at memory address `0x3000`.
2. **Compile and Simulate**: Use `iverilog` to compile the Verilog files and run the simulation.
3. **View Results**: The simulation will display outputs in the terminal or through a waveform viewer like GTKWave.

A Makefile is provided to streamline the compilation and simulation process.

## Testing

- **EPWAVE**: A GTKWave file is included to visualize the test results.
- The project has been tested using a variety of test cases, ensuring the proper functionality of the LC-3 processor.

## Credits

Developed by Antonio Iovine with contribution of the University of Verona.

## License

This project is licensed under the MIT License.
