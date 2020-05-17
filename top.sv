// Project		: COEN 6541 - CALC 2
// File Name	: top.sv
// Description	: This file is used to integrate the test bench with the DUT. 
//
// --------------------------------------------------------------------------

module top; // Define Top module

	parameter simulation_cycle = 100; // Set the simulation_cycle as 100 time units.
    bit a_clk, b_clk, c_clk;
	// for every 50 time units toggle the clock. 
	always #(simulation_cycle/2) 
	begin 
		a_clk = ~a_clk;	
		b_clk = ~b_clk;
		c_clk = ~c_clk;
	end
 
	calc_if cif(a_clk, b_clk, c_clk); 	// Handle for calc1 interface 
	test t1(cif);  					// Testbench program
	calc2_top   c1( cif.out_dataa, cif.out_datab, cif.out_datac, cif.out_datad, cif.out_respa, cif.out_respb, cif.out_respc, cif.out_respd, cif.out_tag_a, cif.out_tag_b, cif.out_tag_c, cif.out_tag_d, cif.scan_out, cif.a_clk, cif.b_clk, cif.c_clk, cif.reqcmd_a, cif.reqa_dataa_in, cif.reqtag_a, cif.reqcmd_b, cif.reqb_dataa_in, cif.reqtag_b, cif.reqcmd_c, cif.reqc_dataa_in, cif.reqtag_c, cif.reqcmd_d, cif.reqd_dataa_in, cif.reqtag_d, cif.reset, cif.scan_in);
endmodule  

// --------------------------------------------------------------------------
// End of top.sv
// --------------------------------------------------------------------------