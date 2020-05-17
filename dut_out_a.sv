// Project		: COEN 6541	- CALC 2
// File Name	: dut_out_A_A.sv
// Description	: This is a transaction file. The transaction is a part of the environment. 
// This holds the fields required to generate the stimulus are declared in the transaction class.
// transaction class can also be used as placeholder for the activity monitored by monitor on 
// DUT signals. This trasaction file is for the dut out to monitor.
//
// --------------------------------------------------------------------------

// Define DUT_OUT_A: 
`ifndef DUT_OUT_A_DEFINE
`define DUT_OUT_A_DEFINE

// Class dut_out_A: 
class dut_out_A;

	// Define output data and response that will be received from the DUT: 
    bit [0:1] out_respa;
    bit [0:1] out_tag_a;
    bit [0:31] out_dataa;
    
	// Function to create a copy of the object of the class dut_out_A: 
	function dut_out_A copy();
		dut_out_A copyresp = new();
		// PORT-A:
		copyresp.out_respa = this.out_respa;
		copyresp.out_dataa = this.out_dataa;
		copyresp.out_tag_a = this.out_tag_a;

		// DEEP COPY
		copy = copyresp;
	endfunction : copy
  
	// Function to print the value received from the DUT: 
	function void print_response(string prefix);
		$display ("\n",$time," : %s PORTA response : %h  out-data1 : %h out-tag1 : %h",prefix, this.out_respa, this.out_dataa, this.out_tag_a);
endfunction : print_response
 
endclass: dut_out_A
`endif
   
// --------------------------------------------------------------------------
// End of dut_out_A.sv
// --------------------------------------------------------------------------