// This is the code for the data path, it connects all the pieces from the building_blocks folder 
// together as described by figure 1 in the lab manual

module datapath( clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, 
		loadc, loads, writenum, write, datapath_in, status, datapath_out);

	// One bit input ports:
	input clk, write, loada,
	       loadb, loadc,
	       loads,vsel, asel, bsel; 		

	// Two bit inputs	
	input [1:0] shift;

	// 16 bit input ports:
	input [15:0] datapath_in;
	
	// 3 bit input ports:
	input [2:0] writenum, readnum, ALUop;
	
	// Outputs:
	output [15:0] datapath_out;
	output status;

	// Signals I will use to internally connect blocks:
	wire [15:0] data_in;
	wire [15:0] data_out;
	wire [15:0] a_to_amux;
	wire [15:0] b_to_bmux;
	wire [15:0] shifter_to_bmux;
	wire [15:0] Ain, Bin;
	wire [15:0] ALU_to_C;
	wire ALU_to_status;
	

	// Describe data path by connecting together all the pieces:

	// This is the mux as described in lab5
	// two_in_mux #(16) mux1( .a1(datapath_in), .a0(datapath_out), .s(vsel), .b(data_in) );

	// This is the lab6 mux that controls mdata, sximm8..etc:
	four_in_mux #(16) mux1( .a3(mdata), .a2(sximm8), .a1({8'b0, PC}), .a0(C), .s(vsel), .b(data_in) );

	regfile registerfile( .data_in(data_in), .writenum(writenum), .write(write), 
			      .readnum(readnum), .clk(clk), .data_out(data_out) );
	
	vDFFE #(16) A( .clk(clk), .en(loada), .in(data_out), .out(a_to_amux) );
	vDFFE #(16) B( .clk(clk), .en(loadb), .in(data_out), .out(b_to_bmux) );	

	shifter #(16) shifter1( .shift(shift), .data_in(b_to_bmux), .data_out(shifter_to_bmux) );
	
	two_in_mux #(16) muxA( .a1(16'b0), .a0(a_to_amux), .s(asel), .b(Ain) );
	two_in_mux #(16) muxB( .a1({11'b0, datapath_in[4:0]}), .a0(shifter_to_bmux), .s(bsel),
			       .b(Bin) );
	
	ALU #(16) ALU1( .Ain(Ain), .Bin(Bin), . ALUop(ALUop), .path_to_C(ALU_to_C), 
		        .path_to_status(ALU_to_status) );

	vDFFE #(16) C( .clk(clk), .en(loadc), .in(ALU_to_C), .out(datapath_out) );

	vDFFE #(1) status1( .clk(clk), .en(loads), .in(ALU_to_status), .out(status) );
endmodule