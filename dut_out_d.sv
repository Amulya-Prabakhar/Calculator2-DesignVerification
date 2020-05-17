// Project		: COEN 6541	- CALC 2
// File Name	: dut_out_D_A.sv
// Description	: This is a transaction file. The transaction is a part of the environment. 
// This holds the fields required to generate the stimulus are declared in the transaction class.
// transaction class can also be used as placeholder for the activity monitored by monitor on 
// DUT signals. This trasaction file is for the dut out to monitor.
//
// --------------------------------------------------------------------------

// Define DUT_OUT_D: 
`ifndef DUT_OUT_D_DEFINE
`define DUT_OUT_D_DEFINE

// Class dut_out_D: 
class dut_out_D;

	// Define output data and response that will be received from the DUT: 
    bit [0:1] out_respd;
    bit [0:1] out_tag_d;
    bit [0:31] out_datad;
    
	// Function to create a copy of the object of the class dut_out_D: 
	function dut_out_D copy();
		dut_out_D copyresp = new();
		// PORT-D:
		copyresp.out_respd = this.out_respd;
		copyresp.out_datad = this.out_datad;
		copyresp.out_tag_d = this.out_tag_d;
		// DEEP COPY
		copy = copyresp;
	endfunction : copy
  
	// Function to print the value received from the DUT: 
	function void print_response(string prefix);
		$display ($time," : %s PORTD response : %h  out-data4 : %h out-tag4 : %h\n",prefix, this.out_respd, this.out_datad,  this.out_tag_d);
	endfunction : print_response
 
endclass: dut_out_D
`endif
   
// --------------------------------------------------------------------------
// End of dut_out_D.sv
// --------------------------------------------------------------------------