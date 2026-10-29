module front_panel (
    input clk,
    input reset,
    input AC0_dep,
    input AC1_dep,
    input AC2_dep,
    input AC3_dep,
    input Mreset,
    input start,
    input cont,
    input deposit,
    input deposit_next,
    input exam,
    input exam_next,
    input memory_step,
    input inst_step,
    input program_load,
    input fp_cont,
    output reg triggerd,
    output reg AC0_depd,
    output reg AC1_depd,
    output reg AC2_depd,
    output reg AC3_depd,
    output reg startd,
    output reg contd,
    output reg depositd,
    output reg examd,
    output reg memory_stepd,
    output reg inst_stepd,
    output reg sw_active,
    output reg deposit_nextd,
    output reg exam_nextd,
    output reg program_loadd,
    output reg fp_trigger
    



);


//  `include "../parameters.v"


  reg [13:0] switchl;
  reg [ 3:0] trig_state;
  reg [ 9:0] cntr;

  parameter reg [2:0]  //integer
  LATCH = 3'b000,
      WAIT  = 3'b001,
      TRIG1 = 3'b010,
      TRIG2 = 3'b011,
      TRIG3 = 3'b100,
      DELAY = 3'b101,
      REENABLE = 3'b110;


  always @(posedge clk) begin
    if (reset) begin
      {AC0_depd, AC1_depd, AC2_depd, AC3_depd} <= 0;
      {startd, contd, depositd, deposit_nextd} <= 0;
      {examd, exam_nextd, memory_stepd, inst_stepd, program_loadd} <= 0;

      switchl <= 0;
      sw_active <= 1'b0;
      trig_state <= LATCH;
      fp_trigger <= 0;
    end else begin
      case (trig_state)
        LATCH: begin
          switchl[3:0] <= switchl[3:0] | {AC0_dep,AC1_dep,AC2_dep,AC3_dep};
          switchl[7:4] <= switchl[7:4] | {start, cont, deposit, deposit_next};
          switchl[12:8] <= switchl[12:8] |{exam, exam_next, memory_step, inst_step, program_load};

          // latch inputs
          if (switchl == 0) trig_state <= LATCH;
          else begin
            trig_state <= WAIT;
          end

        end
        WAIT: begin
          trig_state <= TRIG1;
          {AC0_depd, AC1_depd, AC2_depd, AC3_depd} <= switchl[3:0];
          {startd, contd, depositd, deposit_nextd} <= switchl[7:4];
          {examd, exam_nextd, memory_stepd, inst_stepd, program_loadd} <= switchl[12:8];
          switchl <= 0;
        end
        TRIG1: begin
          trig_state <= TRIG2;
          // switchd <= switchd;
        end
        TRIG2: begin
          trig_state <= TRIG3;
          fp_trigger <= 1;
        end
        TRIG3: begin
          trig_state <= DELAY;
          sw_active  <= 1'b1;
        end
        DELAY:
        if (fp_cont == 1) begin
          trig_state <= REENABLE;
          fp_trigger <= 0;
          sw_active <= 1'b0;
          {AC0_depd, AC1_depd, AC2_depd, AC3_depd} <= 0;
          {startd, contd, depositd, deposit_nextd} <= 0;
          {examd, exam_nextd, memory_stepd, inst_stepd, program_loadd} <= 0;
          triggerd <= 0;
        end else begin
          trig_state <= DELAY;
          {AC0_depd, AC1_depd, AC2_depd, AC3_depd} <= 0;
          {startd, contd, depositd, deposit_nextd} <= 0;
          {examd, exam_nextd, memory_stepd, inst_stepd, program_loadd} <= 0;
          triggerd <= 0;
        end

        REENABLE: begin
          trig_state <= LATCH;
          fp_trigger <= 0;
        end
        default: trig_state <= LATCH;
`ifdef AS
        AS0:
`ifdef AS_RK8E
        begin
          if (disk_rdy == 1) trig_state <= AS1;
          else if (sw == 0) trig_state <= LATCH;  // allows an escape when disk is not functioning
          else trig_state <= AS0;
        end
`else
        trig_state <= AS1;  // CSD case we dont have to wait for disk_rdy
`endif
        AS1: begin
          trig_state <= AS2;
          rsr <= AS_data[data_idx][11:0];
          case (AS_data[data_idx][13:12])
            0: addr_loadd <= 1;
            1: extd_addrd <= 1;
            2: depd <= 1;
            3: contd <= 1;
            default: ;
          endcase
          triggerd <= 1;
        end
        AS2: trig_state <= AS3;
        AS3: trig_state <= AS4;
        AS4: trig_state <= AS5;
        AS5: begin
          triggerd <= 0;
          trig_state <= AS6;
          addr_loadd <= 0;
          extd_addrd <= 0;
          depd <= 0;
          contd <= 0;
        end
        AS6: begin
          if (AS_data[data_idx][13:12] == 2'b11) trig_state <= AS7;  // cont pressed finish loader
          else trig_state <= AS1;
          data_idx <= data_idx + 1;
        end
        AS7: trig_state <= LATCH;
`endif
      endcase
    end
  end
endmodule

// for auto start
// add parameter to compile in auto start
// add a parameter to have the code for CSD loaded
// else load the RK8e boot code
// for RK8e we must wait for the disk_rdy  to assert
// set up arrays for the code and a variable to access them
// 
//  expand the state machine to handle states to load
// state machine assesses the array, sets 12 bits to the sr and 
// uses one of the other four bits to activate the control siganls
// addr_load, extd_addr_load, dep, cont.
// when cont inue is asserted the auto start portion of the state
// machine exits and the normal functions work as normal
// duplicate the state machine for normal for use with autostart, 
// howevery it does not use the fp_trigger, fp_cont signals



