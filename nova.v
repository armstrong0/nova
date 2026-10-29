// it is likely that almost all of the inputs and outputs will need to be
// negated when this is put into an FPGA.  FPGA inputs have a weak pullup,
// so a pin wants to be grounded to assert the signal
// data display - LED to 3.3 volt pin goes to ground to turn it on - a one
`include "../front_panel/front_panel.v"
`include "../front_panel/D_mux.v"
`include "../timing/Clock.v"
`include "../alc/alc.v"


module nova (
    input clock,
    input reset,
    input [0:15] csw,
    input AC0_exam,
    input AC1_exam,
    input AC2_exam,
    input AC3_exam,
    input AC0_dep,
    input AC1_dep,
    input AC2_dep,
    input AC3_dep,
    input Mreset,
    input stop,
    input start,
    input cont,
    input deposit,
    input deposit_next,
    input exam,
    input exam_next,
    input memory_step,
    input inst_step,
    input program_load,
    output [0:14] addr,
    output [0:15] data_disp,
    output carry,
    output fetch,
    output defer,
    output execute,
    output ion
);

  wire clk;
  wire fp_trigger;
  wire oneKHz;
  wire sd_reset;
  wire fp_cont;
  wire [9:0] SlowDiv, FastDiv;
  wire [ 9:0] cntr;
  wire [15:0] baud_count;

  Clock CLK (
      .reset(reset),
      .clk(clk),
      .fp_trigger(fp_trigger),
      .oneKHz(oneKHz),
      .sd_reset(sd_reset),
      .fp_cont(fp_cont),
      .SlowDiv(SlowDiv),
      .FastDiv(FastDiv),
      .cntr(cntr),
      .baud_count(baud_count)  // enough bits to get down to 1200 baud
      // we send the constant rather than generate a clock because RX needs part rate clocks
  );
  wire [0:15] AC0, AC1, AC2, AC3, cSwitch;

  alc ALC (
      .reset(reset),
      .clk(clk),
      .cSwitch(cSwitch),
      .AC0_depd(AC0_depd),
      .AC1_depd(AC1_depd),
      .AC2_depd(AC2_depd),
      .AC3_depd(AC3_depd),
      .AC0(AC0),
      .AC1(AC1),
      .AC2(AC2),
      .AC3(AC3)
  );
  front_panel FP (
      .clk(clk),
      .reset(reset),
      .AC0_dep(AC0_dep),
      .AC1_dep(AC1_dep),
      .AC2_dep(AC2_dep),
      .AC3_dep(AC3_dep),
      .Mreset(Mreset),
      .start(start),
      .cont(cont),
      .deposit(deposit),
      .deposit_next(deposit_next),
      .exam(exam),
      .exam_next(exam_next),
      .memory_step(memory_step),
      .inst_step(inst_step),
      .program_load(program_load),
      .triggerd(triggerd),
      .AC0_depd(AC0_depd),
      .AC1_depd(AC1_depd),
      .AC2_depd(AC2_depd),
      .AC3_depd(AC3_depd)

  );

  D_mux DM (
      .reset(reset),
      .clk(clk),
      .AC0_exam(AC0_exam),
      .AC1_exam(AC1_exam),
      .AC2_exam(AC2_exam),
      .AC3_exam(AC3_exam),
      .AC0(AC0),
      .AC1(AC1),
      .AC2(AC2),
      .AC3(AC3),
      .mout(mout),
      .dDisplay(data_disp)
  );


endmodule

