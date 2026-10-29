`define SIM
`timescale 1 ns / 10 ps
//`include "../timing/clock_frequency.v"
`define PULSE(arg) #1 ``arg <=1 ; #(20*clock_period) ``arg <= 0


module nova_tb;
  reg clock;
  reg reset;
  reg [0:15] csw;
  reg AC0_exam;
  reg AC1_exam;
  reg AC2_exam;
  reg AC3_exam;
  reg AC0_dep;
  reg AC1_dep;
  reg AC2_dep;
  reg AC3_dep;
  reg Mreset;
  reg stop;
  reg start;
  reg cont;
  reg deposit;
  reg deposit_next;
  reg exam;
  reg exam_next;
  reg memory_step;
  reg inst_step;
  reg program_load;
  wire [0:14] addr;
  wire [0:15] data_disp;
  wire carry;
  wire fetch;
  wire defer;
  wire execute;
  wire ion;
`include "../timing/clock_frequency.v"

  nova UUT (
      .clock(clock),
      .reset(reset),
      .csw(csw),
      .AC0_exam(AC0_exam),
      .AC1_exam(AC1_exam),
      .AC2_exam(AC2_exam),
      .AC3_exam(AC3_exam),
      .AC0_dep(AC0_dep),
      .AC1_dep(AC1_dep),
      .AC2_dep(AC2_dep),
      .AC3_dep(AC3_dep),
      .Mreset(Mreset),
      .stop(stop),
      .start(start),
      .cont(cont),
      .deposit(deposit),
      .deposit_next(deposit_next),
      .exam(exam),
      .exam_next(exam_next),
      .memory_step(memory_step),
      .inst_step(inst_step),
      .program_load(program_load),
      .addr(addr),
      .data_disp(data_disp),
      .carry(carry),
      .fetch(fetch),
      .defer(defer),
      .execute(execute),
      .ion(ion)
  );

 always begin  // clock _period comes from parameters.v
    #(clock_period / 2) clock <= 1;
    #(clock_period / 2) clock <= 0;
  end


endmodule



