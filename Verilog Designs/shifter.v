// This is the module for a shifter
//
// INPUTS: path_from_B 16 bit 
// INPUTS: shift 2 bits
//
// OUTPUTS: out 16 bits
//
// This module will preform bit shifts depending on the state of shift (input)

// Constants

`define A 1

module shifter( shift, data_in, data_out );

	parameter k = 1;
	input [1:0] shift;
	input [k-1:0] data_in;
	output reg [k-1:0] data_out;	
	
	always @(*) begin
		if( shift == 2'b00 ) begin
			data_out = data_in;
		end
		else if( shift == 2'b01 ) begin
			data_out = data_in << `A;
		end
		else if( shift == 2'b10 ) begin
			data_out = data_in >> `A;
		end
		else if( shift == 2'b11 ) begin
			data_out = data_in >> `A;
			data_out[k-1] = data_in[k-1];
		end 
		else begin
			data_out = {k{1'bx}};
		end
	end
endmodule	
