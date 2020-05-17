// Project		: COEN 6541	- CALC 2
// File Name	: Transaction.sv
// Description	: The transaction is a part of the environment. 
// This holds the fields required to generate the stimulus are declared in the transaction class.
// transaction class can also be used as placeholder for the activity monitored by monitor on 
// DUT signals. This trasaction file is for the generator to driver. 
//
// --------------------------------------------------------------------------

// Define the Calc interface:
`ifndef IF_DEFINE
`define IF_DEFINE
// Define the Calc1 Transaction:
`ifndef TRANS_DEFINE
`define TRANS_DEFINE

// Class Transaction: 
class Transaction;
 
	// Create user defined Data types for request command and input data: 
	typedef logic [0:3] cmd;
	typedef logic [0:1] tag;
	typedef logic [0:31] data;
 
	// Randomize the request command: 
	rand cmd reqcmd_a;
	rand cmd reqcmd_b;
	rand cmd reqcmd_c;
	rand cmd reqcmd_d;
	
	// Randomize the request tag: 
	randc tag reqtag_a;
	randc tag reqtag_b;
	randc tag reqtag_c;
	randc tag reqtag_d;	
	
	// Request command can have any one of the values: 0,1,2,5,6:
	constraint reqcmd_c1 {reqcmd_a inside {1,2,5,6};}
	constraint reqcmd_c2 {reqcmd_b inside {1,2,5,6};}
	constraint reqcmd_c3 {reqcmd_c inside {1,2,5,6};}
	constraint reqcmd_c4 {reqcmd_d inside {1,2,5,6};}
	
	// Request command can have any one of the values: 0,1,2,3:
	constraint reqtag_a_c1 {reqtag_a inside {0,1,2,3};}
	constraint reqtag_b_c2 {reqtag_b inside {0,1,2,3};}
	constraint reqtag_c_c3 {reqtag_c inside {0,1,2,3};}
	constraint reqtag_d_c4 {reqtag_d inside {0,1,2,3};}	
	
	// Randomize the Input Data-a and Input Data-b on all the ports:  
	rand data reqa_dataa_in, reqa_datab_in;
	rand data reqb_dataa_in, reqb_datab_in;  
	rand data reqc_dataa_in, reqc_datab_in;
	rand data reqd_dataa_in, reqd_datab_in;

	// Reset: 
	bit reset = 0;
 
	// Define the statice variable count and initialize it to '0':
	static int count=0;
	int ALU_count_a=0, Shift_count_a=0, nop_count_a=0;
	int ALU_count_b=0, Shift_count_b=0, nop_count_b=0;
	int ALU_count_c=0, Shift_count_c=0, nop_count_c=0;
	int ALU_count_d=0, Shift_count_d=0, nop_count_d=0;
	
	int id, trans_cnt;
	
	// Constructor: 
	function new;
		id = count++; // Increment the ID to note down the number of transaction
	endfunction
 
	// Function to print the data that has been generated:
	function void print_trans(string prefix);
   		$display ($time," : %s PORTA opcode : %d  dataa : %h datab : %h	tag: %h ALU_count_a: %d Shift_count_a: %d nop_count_a: %d",prefix, this.reqcmd_a, this.reqa_dataa_in, this.reqa_datab_in, this.reqtag_a, this.ALU_count_a, this.Shift_count_a, this.nop_count_a);
		$display ($time," : %s PORTB opcode : %d  dataa : %h datab : %h	tag: %h ALU_count_b: %d Shift_count_b: %d nop_count_b: %d",prefix, this.reqcmd_b, this.reqb_dataa_in, this.reqb_datab_in, this.reqtag_b, this.ALU_count_b, this.Shift_count_b, this.nop_count_b);
		$display ($time," : %s PORTC opcode : %d  dataa : %h datab : %h	tag: %h ALU_count_c: %d Shift_count_c: %d nop_count_c: %d",prefix, this.reqcmd_c, this.reqc_dataa_in, this.reqc_datab_in, this.reqtag_c, this.ALU_count_c, this.Shift_count_c, this.nop_count_c);
		$display ($time," : %s PORTD opcode : %d  dataa : %h datab : %h	tag: %h ALU_count_d: %d Shift_count_d: %d nop_count_d: %d",prefix, this.reqcmd_d, this.reqd_dataa_in, this.reqd_datab_in, this.reqtag_d, this.ALU_count_d, this.Shift_count_d, this.nop_count_d);
	endfunction: print_trans
 
	// Function to create a copy of the object:
	function Transaction copy();
 
		Transaction copytr = new();
		//PORT-A:
		copytr.reqcmd_a = this.reqcmd_a;
		copytr.reqa_dataa_in = this.reqa_dataa_in;
		copytr.reqa_datab_in = this.reqa_datab_in;
		copytr.reqtag_a = this.reqtag_a;
		// PORT-B:
		copytr.reqcmd_b = this.reqcmd_b;
		copytr.reqb_dataa_in = this.reqb_dataa_in;
		copytr.reqb_datab_in = this.reqb_datab_in;
		copytr.reqtag_b = this.reqtag_b;
		// PORT-C:
		copytr.reqcmd_c = this.reqcmd_c;
		copytr.reqc_dataa_in = this.reqc_dataa_in;
		copytr.reqc_datab_in = this.reqc_datab_in;
		copytr.reqtag_c = this.reqtag_c;
		// PORT-D:
		copytr.reqcmd_d = this.reqcmd_d;
		copytr.reqd_dataa_in = this.reqd_dataa_in;
		copytr.reqd_datab_in = this.reqd_datab_in;
		copytr.reqtag_d = this.reqtag_d;

		this.ALU_count_a=0;
		this.ALU_count_b=0;
		this.ALU_count_c=0;
		this.ALU_count_d=0;
		
		this.Shift_count_a=0;
		this.Shift_count_b=0;
		this.Shift_count_c=0;
		this.Shift_count_d=0;
		
		this.nop_count_a=0;
		this.nop_count_b=0;
		this.nop_count_c=0;
		this.nop_count_d=0;
		
		if (this.reqcmd_a == 1 || this.reqcmd_a == 2)
			this.ALU_count_a++;
		if (this.reqcmd_b == 1 || this.reqcmd_b == 2)
			this.ALU_count_b++;
		if (this.reqcmd_c == 1 || this.reqcmd_c == 2)
			this.ALU_count_c++;
		if (this.reqcmd_d == 1 || this.reqcmd_d == 2)
			this.ALU_count_d++;			
		if (this.reqcmd_a == 5 || this.reqcmd_a == 6)
			this.Shift_count_a++;
		if (this.reqcmd_b == 5 || this.reqcmd_b == 6)
			this.Shift_count_b++;
		if (this.reqcmd_c == 5 || this.reqcmd_c == 6)
			this.Shift_count_c++;
		if (this.reqcmd_d == 5 || this.reqcmd_d == 6)
			this.Shift_count_d++;
		if (this.reqcmd_a == 0)
			this.nop_count_a++;
		if (this.reqcmd_b == 0)
			this.nop_count_b++;
		if (this.reqcmd_c == 0)
			this.nop_count_c++;
		if (this.reqcmd_d == 0)
			this.nop_count_d++;
			
		copytr.ALU_count_a=this.ALU_count_a;
		copytr.ALU_count_b=this.ALU_count_b;
		copytr.ALU_count_c=this.ALU_count_c;
		copytr.ALU_count_d=this.ALU_count_d;
		
		copytr.Shift_count_a=this.Shift_count_a;
		copytr.Shift_count_b=this.Shift_count_b;
		copytr.Shift_count_c=this.Shift_count_c;
		copytr.Shift_count_d=this.Shift_count_d;
		
		copytr.nop_count_a=this.nop_count_a;
		copytr.nop_count_b=this.nop_count_b;
		copytr.nop_count_c=this.nop_count_c;
		copytr.nop_count_d=this.nop_count_d;
		
		// Deep copy:
		copy = copytr;
		
		this.ALU_count_a=0;
		this.ALU_count_b=0;
		this.ALU_count_c=0;
		this.ALU_count_d=0;
		
		this.Shift_count_a=0;
		this.Shift_count_b=0;
		this.Shift_count_c=0;
		this.Shift_count_d=0;
		
		this.nop_count_a=0;
		this.nop_count_b=0;
		this.nop_count_c=0;
		this.nop_count_d=0;
		
	endfunction: copy
 
endclass: Transaction
`endif 
`endif

// --------------------------------------------------------------------------
// End of Transaction.sv
// --------------------------------------------------------------------------