
## 1. General Information
- Direct Digital Synthesizer (DDS) implemented on Artix-7 FPGA. 
- The objective is to design and implement parametric digital system capable of generating high-precision harmonic signals using FPGA resources

## 2. Functional Requirements
The system is able to provide the following functionalities:
- Continuous waveform generation
- Real-time frequency tuning
- Phase reset
- Analog audio output

## 3. Structure and Design
The architecture follows a modular synchronous design pattern:
 
| Module            | Responsibility                                                         |
| ----------------- | ---------------------------------------------------------------------- |
| Clock Divider     | Generates `CE` pulse at ≈48kHz using 100MHz source.                    |
| Phase Accumulator | Increments the current phase by the value of `SW` every `CE` pulse.    |
| Sine LUT (ROM)    | A Look-Up Table which stores 512 8-bit samples of a single sine period |
| PWM Generator     | Converts 8-bit amplitude data into high-frequency 1-bit stream         |
| Top Module        | Connects all components into one design                                |

## 4. Technical Parameters
- Hardware Platform: Xilinx Nexys A7-100T (XC7A100T-1CSG324C)
- System Clock: 100MHz 
- Sampling Frequency: ≈48kHz
- Accumulator Width: 16 bits (N = 16)
- Sine ROM: 512 samples, 8-bit resolution
- Output frequency formula: 
$$f_{out} = \frac{M \cdot f_{sample}}{2^{N}}$$  
Where `M` is a 16-bit value from the switches.

## 5. Criteria for Success
The project is considered complete if it meets the following requirements:
- [X] Clean Synthethis: No "Critical Warnings" and timing violations in the Vivado report.
- [ ] Frequency accuracy: The output frequency matches the theoretical value calculated by the formula.
- [ ] Function Purity: the sine wave is visually smooth on an oscilloscope after the RC filter.
- [ ] Code Reusability: Parameters like `ACC_WIDTH` can be changed without breaking into the logic.
