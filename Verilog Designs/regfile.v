//-----------------------------------------------------------------------------------
// This module insantiates the following building blocks to create a register file
//
//
// 3:8 decoder           x2
// load enable registers x8
// 8 input one-hot mux   x1
//
// INPUTS : writenum [2:0]
//	  : write 
//        : data_in [15:0]
//	  : clk
//     	  : readnum [2:0]
// OUTPUTS: data_out
// 
//-----------------------------------------------------------------------------------


module regfile ( writenum, write, data_in, clk, readnum, data_out );

	input [2:0] writenum;
	input write, clk;
	input [15:0] data_in;
	input [2:0] readnum;

	output [15:0] data_out;

	// Signals I will use to connect components:
	wire [7:0] dec1_out;	
	reg [7:0] reg_en;
	wire [15:0] reg_out0;
	wire [15:0] reg_out1;
	wire [15:0] reg_out2;
	wire [15:0] reg_out3;
	wire [15:0] reg_out4;
	wire [15:0] reg_out5;
	wire [15:0] reg_out6;
	wire [15:0] reg_out7;
	wire [7:0] select;

	decoder #(3,8) dec1( .a(writenum), .b(dec1_out) );
	
	// Whenever write or dec1_out changes AND together the output of the decoder 
	// and the value of write. This signal will then feed into the registers's load
	
	always @(*) begin
		reg_en[0] = write & dec1_out[0];
		reg_en[1] = write & dec1_out[1];
		reg_en[2] = write & dec1_out[2];
		reg_en[3] = write & dec1_out[3];
		reg_en[4] = write & dec1_out[4];
		reg_en[5] = write & dec1_out[5];
		reg_en[6] = write & dec1_out[6];
		reg_en[7] = write & dec1_out[7];
	end

	// Instantiate 8 load enable registers. 16-bit inputs:

	vDFFE #(16) R0( .clk(clk), .en(reg_en[0]), .in(data_in), .out(reg_out0));
        vDFFE #(16) R1( .clk(clk), .en(reg_en[1]), .in(data_in), .out(reg_out1));
        vDFFE #(16) R2( .clk(clk), .en(reg_en[2]), .in(data_in), .out(reg_out2));
        vDFFE #(16) R3( .clk(clk), .en(reg_en[3]), .in(data_in), .out(reg_out3));
        vDFFE #(16) R4( .clk(clk), .en(reg_en[4]), .in(data_in), .out(reg_out4));
        vDFFE #(16) R5( .clk(clk), .en(reg_en[5]), .in(data_in), .out(reg_out5));
        vDFFE #(16) R6( .clk(clk), .en(reg_en[6]), .in(data_in), .out(reg_out6));
        vDFFE #(16) R7( .clk(clk), .en(reg_en[7]), .in(data_in), .out(reg_out7));
		
	// Decode the 3 bit binary signal readnum into 8 bit one-hot code for the mux:

	decoder #(3,8) dec2( readnum, select );
	
	// Run signals through mux before outputing:

	eight_in_mux #(16) mux8( .a7(reg_out7), .a6(reg_out6), .a5(reg_out5), .a4(reg_out4), .a3(reg_out3),
			    .a2(reg_out2), .a1(reg_out1), .a0(reg_out0), .s(select), .b(data_out) );

endmodule