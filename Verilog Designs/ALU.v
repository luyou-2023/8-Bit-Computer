//******************************************
// This is the ALU component
//
// INPUTS:  Ain 16 bits 
// INPUTS:  Bin 16 bits
// INPUTS:  ALUop 2 bits
// OUTPUTS: path_to_C 16 bits
// OUTPUTS: path_to_status 1 bit
//
// This Arithmetic Logic Unit has the
// following truth table:
// 
// _____________________
// | ALUop | path_to_C |
// ---------------------
// |  00   | Ain + Bin |
// ---------------------
// |  01   | Ain - Bin |
// ---------------------
// |  10   | Ain & Bin |
// ---------------------
// |  11   |    ~Bin   |
// ---------------------
//
// The size of Ain, Bin, and path_to_C can
// be paramertized
// The path_to_status has logic value 1 
// when path_to_C is k'b0, else 0 
// 
//****************************************


module ALU( Ain, Bin, ALUop, path_to_C, path_to_status );
	
	parameter k = 1;

	input [k-1:0] Ain;
	input [k-1:0] Bin;
	input [2:0] ALUop;
	
	output reg [k-1:0] path_to_C;
	output reg path_to_status;

	always @(*) begin

		// This controls the path_to_C signal
		case(ALUop) 
		  2'b00   : path_to_C = Ain + Bin;
		  2'b01   : path_to_C = Ain - Bin;
		  2'b10   : path_to_C = Ain & Bin;
		  2'b11   : path_to_C = ~Bin;
		  default : path_to_C = {k{1'bx}};
		endcase
		
		// This controls the path_to_status signal
		case(path_to_C)
		  {k{1'b0}} : path_to_status = 1'b1;
		  default   : path_to_status = 1'b0;
		endcase
	end
endmodule
