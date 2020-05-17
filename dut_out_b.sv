// Project		: COEN 6541	- CALC 2
// File Name	: dut_out_B_A.sv
// Description	: This is a transaction file. The transaction is a part of the environment. 
// This holds the fields required to generate the stimulus are declared in the transaction class.
// transaction class can also be used as placeholder for the activity monitored by monitor on 
// DUT signals. This trasaction file is for the dut out to monitor.
//
// --------------------------------------------------------------------------

// Define DUT_OUT_B: 
`ifndef DUT_OUT_B_DEFINE
`define DUT_OUT_B_DEFINE

// Class dut_out_B: 
class dut_out_B;

	// Define output data and response that will be received from the DUT: 
    bit [0:1] out_respb;
    bit [0:1] out_tag_b;
    bit [0:31] out_datab;
    
	// Function to create a copy of the object of the class dut_out_B: 
	function dut_out_B copy();
		dut_out_B copyresp = new();
		// PORT-B:
		copyresp.out_respb = this.out_respb;
		copyresp.out_datab = this.out_datab;
		copyresp.out_tag_b = this.out_tag_b;
		// DEEP COPY
		copy = copyresp;
	endfunction : copy
  
	// Function to print the value received from the DUT: 
	function void print_response(string prefix);
		$display ($time," : %s PORTB response : %h  out-data2 : %h out-tag2 : %h",prefix, this.out_respb, this.out_datab, this.out_tag_b);
	endfunction : print_response
 
endclass: dut_out_B
`endif
   
// --------------------------------------------------------------------------
// End of dut_out_B.sv
// --------------------------------------------------------------------------