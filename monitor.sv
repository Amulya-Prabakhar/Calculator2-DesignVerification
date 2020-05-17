// Project		: COEN 6541 - CALC 2
// File Name	: calc_monitor.sv
// Description	: The monitor is a part of the environment. Monitor converts
// outputs of DUT to low level transaction results
// 
// --------------------------------------------------------------------------

// Define the Monitor interface: 
`define CALC_MONITOR_IF	calc_monitor_if.monitor_cb

// Include the transaction, dut_out and interface files: 
`include "env/Transaction.sv"
`include "env/dut_out_a.sv"
`include "env/dut_out_b.sv"
`include "env/dut_out_c.sv"
`include "env/dut_out_d.sv"
`include "env/IF.sv"

// Class Monitor: 
class monitor;
	
	// Declare variables for verbose and transaction count: 
	bit verbose;
	int trans_cnt = 0;
	int total_ALU_count=0, total_shift_count=0,total_nop_count=0;
	
	int ALU_count_a 	=0 ,ALU_count_b 	=0 ,ALU_count_c 	=0 ,	ALU_count_d		=0; 
	int Shift_count_a 	=0 ,Shift_count_b 	=0 ,Shift_count_c 	=0 ,	Shift_count_d   =0; 
	int nop_count_a 	=0 ,nop_count_b 	=0 ,nop_count_c 	=0 ,	nop_count_d     =0; 
	
	// Handle for the class dut_out: used to get outputs from the DUT:
	Transaction to_dut_count;
	dut_out_A from_dut_A;
	dut_out_B from_dut_B;
	dut_out_C from_dut_C;
	dut_out_D from_dut_D;
	
	virtual calc_if.monitor calc_monitor_if;	// Virtual interface for calc_monitor
	mailbox #(Transaction) gen2mon;					// mailbox to send data from gen to monitor.
    mailbox #(dut_out_A) mon2scb_A;					// mailbox to send the data from the monitor to scoreboard.
    mailbox #(dut_out_B) mon2scb_B;					// mailbox to send the data from the monitor to scoreboard.
    mailbox #(dut_out_C) mon2scb_C;					// mailbox to send the data from the monitor to scoreboard.
    mailbox #(dut_out_D) mon2scb_D;					// mailbox to send the data from the monitor to scoreboard.
  
	// Constructor Function: 
	function new(virtual calc_if.monitor calc_monitor_if,mailbox #(dut_out_A) mon2scb_A, mailbox #(dut_out_B) mon2scb_B, mailbox #(dut_out_C) mon2scb_C, mailbox #(dut_out_D) mon2scb_D,mailbox #(Transaction) gen2mon, bit verbose = 0); 
		this.calc_monitor_if = calc_monitor_if;
		this.mon2scb_A = mon2scb_A;
		this.mon2scb_B = mon2scb_B;
		this.mon2scb_C = mon2scb_C;
		this.mon2scb_D = mon2scb_D;
		this.gen2mon   = gen2mon;
		this.verbose = verbose;
	endfunction : new
  
	// Main Task:
	task main(); 
		to_dut_count = new();
		from_dut_A= new();
		from_dut_B= new();
		from_dut_C= new();
		from_dut_D= new();
		
		// Get count from generator:
		gen2mon.get(to_dut_count);
		
		total_ALU_count= to_dut_count.ALU_count_a + to_dut_count.ALU_count_b + to_dut_count.ALU_count_c + to_dut_count.ALU_count_d;
		total_shift_count= to_dut_count.Shift_count_a + to_dut_count.Shift_count_b + to_dut_count.Shift_count_c + to_dut_count.Shift_count_d;
		total_nop_count= to_dut_count.nop_count_a + to_dut_count.nop_count_b + to_dut_count.nop_count_c + to_dut_count.nop_count_d;
		
		this.ALU_count_a 	=to_dut_count.ALU_count_a;
		this.ALU_count_b 	=to_dut_count.ALU_count_b;
		this.ALU_count_c 	=to_dut_count.ALU_count_c;
		this.ALU_count_d	=to_dut_count.ALU_count_d;
		
		this.Shift_count_a 	=to_dut_count.Shift_count_a;
		this.Shift_count_b 	=to_dut_count.Shift_count_b;
		this.Shift_count_c  =to_dut_count.Shift_count_c;
		this.Shift_count_d  =to_dut_count.Shift_count_d;
		
		this.nop_count_a 	=to_dut_count.nop_count_a;
		this.nop_count_b 	=to_dut_count.nop_count_b;
		this.nop_count_c 	=to_dut_count.nop_count_c;
		this.nop_count_d 	=to_dut_count.nop_count_d; 
  
		forever begin
		
		if (total_ALU_count > 0 || total_shift_count > 0 || total_nop_count > 0)
		begin 
		fork
				// Get responses only when there is an input command:
				
				if (this.ALU_count_a == 1) 		out_get_response_A();
				if (this.ALU_count_b == 1)		out_get_response_B();				
				if (this.ALU_count_c == 1)		out_get_response_C();				
				if (this.ALU_count_d == 1) 		out_get_response_D();				
				
				if (this.Shift_count_a== 1)		out_get_response_A();
				if (this.Shift_count_b== 1)		out_get_response_B();			
				if (this.Shift_count_c== 1)		out_get_response_C();	
				if (this.Shift_count_d== 1)		out_get_response_D();
				
				if (this.nop_count_a== 1)		out_get_response_A();
				if (this.nop_count_b== 1)       out_get_response_B();
				if (this.nop_count_c== 1)       out_get_response_C();
				if (this.nop_count_d== 1)       out_get_response_D();			
		join
		end
		
		#100;
		
				
		if (verbose)
			from_dut_A.print_response("monitor");
			from_dut_B.print_response("monitor");
			from_dut_C.print_response("monitor");
			from_dut_D.print_response("monitor");
		end
	endtask : main

	// Task to get the response from the DUT:

	// PORT-A
	task out_get_response_A (); 
	begin
		
			@(`CALC_MONITOR_IF.out_dataa or `CALC_MONITOR_IF.out_respa == 0 or `CALC_MONITOR_IF.out_respa == 1 or `CALC_MONITOR_IF.out_respa == 2 or `CALC_MONITOR_IF.out_respa == 3);
			$display("\n",$time, "   ----------Monitor Recieving data from Port -A out of Dut----------");
			from_dut_A.out_respa = `CALC_MONITOR_IF.out_respa;
			from_dut_A.out_dataa = `CALC_MONITOR_IF.out_dataa;
			from_dut_A.out_tag_a = `CALC_MONITOR_IF.out_tag_a;
			$display($time," : out_respa %h",from_dut_A.out_respa);
			$display($time," : out_dataa %h",from_dut_A.out_dataa);
			$display($time," : out_tag_a %h",from_dut_A.out_tag_a);
			mon2scb_A.put(from_dut_A); // Forward the values to the Scoreboard using mail box. 
			
			
	
	end
	endtask: out_get_response_A
	
	// PORT-B
	task out_get_response_B (); 
	begin
			@(`CALC_MONITOR_IF.out_datab or `CALC_MONITOR_IF.out_respb == 0 or `CALC_MONITOR_IF.out_respb == 1 or `CALC_MONITOR_IF.out_respb == 2 or `CALC_MONITOR_IF.out_respb == 3);
			$display("\n",$time, "   ----------Monitor Recieving data from Port -B out of Dut----------"); 
			from_dut_B.out_respb = `CALC_MONITOR_IF.out_respb;
			from_dut_B.out_datab = `CALC_MONITOR_IF.out_datab;
			from_dut_B.out_tag_b = `CALC_MONITOR_IF.out_tag_b;
			$display($time," : out_respb %h",from_dut_B.out_respb);
			$display($time," : out_datab %h",from_dut_B.out_datab);
			$display($time," : out_tag_b %h",from_dut_B.out_tag_b);
			mon2scb_B.put(from_dut_B); // Forward the values to the Scoreboard using mail box. 
	
	end
	endtask: out_get_response_B

	// PORT-C:		
	task out_get_response_C (); 
	begin
		
			@(`CALC_MONITOR_IF.out_datac or `CALC_MONITOR_IF.out_respc == 0 or `CALC_MONITOR_IF.out_respc == 1 or `CALC_MONITOR_IF.out_respc == 2 or `CALC_MONITOR_IF.out_respc == 3);
			$display("\n",$time, "   ----------Monitor Recieving data from Port -C out of Dut----------");	
			from_dut_C.out_respc = `CALC_MONITOR_IF.out_respc;
			from_dut_C.out_datac = `CALC_MONITOR_IF.out_datac;
			from_dut_C.out_tag_c = `CALC_MONITOR_IF.out_tag_c;
			$display($time," : out_respc %h",from_dut_C.out_respc);
			$display($time," : out_datac %h",from_dut_C.out_datac);
			$display($time," : out_tag_c %h",from_dut_C.out_tag_c);
			mon2scb_C.put(from_dut_C); // Forward the values to the Scoreboard using mail box. 
	
	end
	endtask: out_get_response_C

	// PORT-D:		
	task out_get_response_D (); 
	begin
		
			@(`CALC_MONITOR_IF.out_datad or `CALC_MONITOR_IF.out_respd == 0 or `CALC_MONITOR_IF.out_respd == 1 or `CALC_MONITOR_IF.out_respd == 2 or `CALC_MONITOR_IF.out_respd == 3);
			$display("\n",$time, "   ----------Monitor Recieving data from Port -D out of Dut----------");
			from_dut_D.out_respd = `CALC_MONITOR_IF.out_respd;
			from_dut_D.out_datad = `CALC_MONITOR_IF.out_datad;
			from_dut_D.out_tag_d = `CALC_MONITOR_IF.out_tag_d;
			$display($time," : out_respd %h",from_dut_D.out_respd);
			$display($time," : out_datad %h",from_dut_D.out_datad);
			$display($time," : out_tag_d %h\n",from_dut_D.out_tag_d);
			mon2scb_D.put(from_dut_D); // Forward the values to the Scoreboard using mail box. 
	
	end
	endtask: out_get_response_D		

endclass : monitor

// --------------------------------------------------------------------------
// End of monitor.sv
// --------------------------------------------------------------------------
  