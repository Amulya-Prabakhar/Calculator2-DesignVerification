// Project		: COEN 6541	- CALC 2
// File Name	: dut_out_C_A.sv
// Description	: This is a transaction file. The transaction is a part of the environment. 
// This holds the fields required to generate the stimulus are declared in the transaction class.
// transaction class can also be used as placeholder for the activity monitored by monitor on 
// DUT signals. This trasaction file is for the dut out to monitor.
//
// --------------------------------------------------------------------------

// Define DUT_OUT_C: 
`ifndef DUT_OUT_C_DEFINE
`define DUT_OUT_C_DEFINE

// Class dut_out_C: 
class dut_out_C;

	// Define output data and response that will be received from the DUT: 
    bit [0:1] out_respc;
    bit [0:1] out_tag_c;
    bit [0:31] out_datac;
    
	// Function to create a copy of the object of the class dut_out_C: 
	function dut_out_C copy();
		dut_out_C copyresp = new();
		// PORT-C:
		copyresp.out_respc = this.out_respc;
		copyresp.out_datac = this.out_datac;
		copyresp.out_tag_c = this.out_tag_c;

		// DEEP COPY
		copy = copyresp;
	endfunction : copy
  
	// Function to print the value received from the DUT: 
	function void print_response(string prefix);
		$display ($time," : %s PORTC response : %h  out-data3 : %h out-tag3 : %h",prefix, this.out_respc, this.out_datac, this.out_tag_c);
	endfunction : print_response
 
endclass: dut_out_C
`endif
   
// --------------------------------------------------------------------------
// End of dut_out_C.sv
// --------------------------------------------------------------------------