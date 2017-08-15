# LC-3 in VHDL

This README documents the design specifics of this implementation which might not be obvious and straightforward. Contained in the test_asm folder is a sample assembly code, both in assembly and binary, that can run on this implementation. In general, this implementation supports the entire LC-3 ISA. The sample code covers only a small subset of it.

## Contents
1. [FSM Control](#fsm-control)
2. [LC-3](#lc-3)
3. [RAM](#ram)
4. [16b Register](#16b-register)
5. [Register File](#register-file)

#### FSM Control

FSM control is the only clocked component in the entire implementation. It is a a microcoded FSM, i.e. control signals for all opcodes are stored in respective ROMs. Bit-steering, wherever applicable, is done in a sequential process block.

#### LC-3

This file binds all the components together to form the processor. All sign extensions are done in this file. Furthermore, the central bus of the LC-3 is simple represented here as a 16b signal.

#### RAM

The RAM is an unclocked 64K module. As stated above, FSM is the only clocked component in the entire design. Hardcoded into the RAM is the program code, starting at address 0. The test code is the same as in test_asm directory.

#### 16b Register

The 16b registers are 16 latches, again with no clock. The registers are controlled with a LE (Load Enable) signal for read/write.

#### Register File

The register file contains the 8 GPRs, as documented in the book by P&P. It also contains two additional registers for SR1 and SR2. Whenever LE for register file is 1, the LE for SR1 and SR2 registers is set to 0, preserving old values in them. After the register file is updated, SR1 and SR2 can again start loading new values.
