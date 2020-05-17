// Project		: COEN 6541 - CALC 2
// File Name	: test.sv
// Description	: This file is used to integrate the test bench with the DUT. 
//
// --------------------------------------------------------------------------

// include the calc interface:
`include "env/IF.sv"

// Program to test: 
program automatic test(calc_if calcif);

	`include "env/env.sv" 	// Top level environment
	env the_env;			// Handle for the environment: 

	initial 
	begin
		// Instanciate the top level
		the_env = new(calcif);

		// Kick off the test now
		the_env.run();

		$finish;
	end 
endprogram

// --------------------------------------------------------------------------
// End of test.sv
// --------------------------------------------------------------------------