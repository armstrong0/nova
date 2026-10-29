module alc (
    input reset,
    input clk,
    input [0:15] cSwitch,
    input AC0_depd,
    AC1_depd,
    AC2_depd,
    AC3_depd,
    output reg [0:15] AC0,
    AC1,
    AC2,
    AC3
);

  always @(posedge clk) begin
    if (reset == 1) begin
      AC0 <= 0;
      AC1 <= 0;
      AC2 <= 0;
      AC3 <= 0;
    end else begin
      if (AC0_depd == 1) AC0 <= cSwitch;
      if (AC1_depd == 1) AC1 <= cSwitch;
      if (AC2_depd == 1) AC2 <= cSwitch;
      if (AC3_depd == 1) AC3 <= cSwitch;
    end
  end
endmodule

