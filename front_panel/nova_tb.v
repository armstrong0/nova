`define SIM
`timescale 1 ns / 10 ps
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
  reg fp_cont;
  wire [0:14] addr;
  wire [0:15] data_disp;
  wire carry;
  wire fetch;
  wire defer;
  wire execute;
  wire ion;
  wire fp_trigger;
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
      //.fp_cont (fp_cont),
      //.fp_trigger (fp_trigger),
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

  initial begin

    $dumpfile("front.vcd");
    $dumpvars(0, UUT);
    #1 reset <= 1;
    #50 reset <= 0;
    #1 AC0_exam <= 0;
    #1 AC1_exam <= 0;
    #1 AC2_exam <= 0;
    #1 AC3_exam <= 0;
    #1 AC0_dep <= 0;
    #1 AC1_dep <= 0;
    #1 AC2_dep <= 0;
    #1 AC3_dep <= 0;
    #1 start <= 0;
    #1 cont <= 0;
    #1 deposit <= 0;
    #1 deposit_next <= 0;
    #1 exam <= 0;
    #1 exam_next <= 0;
    #1 memory_step <= 0;
    #1 inst_step <= 0;
    #1 program_load <= 0;
    #1 reset <= 0;
    #1 reset <= 1;
    #20 reset <= 0;

    #1 exam <= 1;
    #100 exam <= 0;
    #1000 $finish;
  end

endmodule



