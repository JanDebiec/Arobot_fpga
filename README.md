# Arobot_fpga

The implementation of stepper motor controller in FPGA.  
The main development work is made in the branch "develop".

The structure of the repository:

  Name of folder | Content   
| ---- | ---- |  
| source/ | The source in VHDL |
| simulation/ | ".do" files for simulation in Modelsim |
| testbench/ | ".vhdl" testbench files for simulation |
| synth_c4/  | synthesis in Altera Cyclone C4 |
| synth_c5/  | synthesis in Altera Cyclone C5 |

The main component is 1 Axis controller.  
  *  Input: Velocity 16 bit signed
  *  Output: 4 PWM outputs for driving 2 phases of stepper motor.
  *  Feedback: 32 register signed, position

The run time parameters:  
  *  microsteps/step (from 1 to 16)
  *  Ramp  (allowed changes of actual velocity pro one system tick)

The compile time parameters:  
  *  System Tick (Freq when the new velocity will be calculated)
  *  PWM Output freq
