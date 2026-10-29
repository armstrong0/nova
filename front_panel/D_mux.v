module D_mux (
    input reset,
    input clk,
    input AC0_exam,
    input AC1_exam,
    input AC2_exam,
    input AC3_exam,
    input [0:15] AC0,
    AC1,
    AC2,
    AC3,
    mout,
    output reg [0:15] dDisplay

);

  always @(posedge clk) begin
    if (reset) dDisplay <= 0;
    else if (AC0_exam == 1) dDisplay <= AC0;
    else if (AC1_exam == 1) dDisplay <= AC1;
    else if (AC2_exam <= 1) dDisplay <= AC2;
    else if (AC3_exam == 1) dDisplay <= AC3;
    else dDisplay <= mout;
  end

endmodule

