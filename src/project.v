/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_secA_group5_array_multiplier (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.

  wire [3:0] m = ui_in[7:4];
  wire [3:0] q = ui_in[3:0];
  wire [7:0] p;
  
  wire [16:0] int;
  assign p[0] = m[0] & q[0];
  full_adder fa00(m[1] & q[0], m[0] & q[1], 1'b0, p[1], int[0]);
  full_adder fa01(m[2] & q[0], m[1] & q[1], int[0], int[1], int[2]);
  full_adder fa02(m[3] & q[0], m[2] & q[1], int[2], int[3], int[4]);
  full_adder fa03(1'b0, m[3] & q[1], int[4], int[5], int[6]);
  full_adder fa10(m[0] & q[2], int[1], 1'b0, p[2], int[7]);
  full_adder fa11(m[1] & q[2], int[3], int[7], int[8], int[9]);
  full_adder fa12(m[2] & q[2], int[5], int[9], int[10], int[11]);
  full_adder fa13(m[3] & q[2], int[6], int[11], int[12], int[13]);
  full_adder fa20(m[0] & q[3], int[8], 1'b0, p[3], int[14]);
  full_adder fa21(m[1] & q[3], int[14], int[10], p[4], int[15]);
  full_adder fa22(m[2] & q[3], int[15], int[12], p[5], int[16]);
  full_adder fa23(m[3] & q[3], int[16], int[13], p[6], p[7]);

  assign uo_out = p;
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};

endmodule

module full_adder(
    input a,
    input b,
    input carry_in,
    output sum,
    output carry_out
    );
        
    assign sum = a ^ b ^ carry_in;
    assign carry_out = (a & b) | (b & carry_in) | (carry_in & a);
     
endmodule