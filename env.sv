// Project		: COEN 6541 - CALC 2
// File Name	: env.sv
// Description	: The environment file acts as the top file for the entire 
// test bench environment. 
//
// --------------------------------------------------------------------------

// Include all the files of the calc environment:
`include "env/Transaction.sv"
`include "env/IF.sv"
`include "env/driver.sv"
`include "env/monitor.sv"
`include "env/gen.sv"
`include "env/scoreboard.sv"
`include "env/dut_out_a.sv"
`include "env/dut_out_b.sv"
`include "env/dut_out_c.sv"
`include "env/dut_out_d.sv"
import A::coverage;

// Class test end: 
class test_end;
  
	rand int trans_cnt;
	constraint count {(trans_cnt >0) && (trans_cnt <= 15);}
  
endclass: test_end

// Class Environment
class env;
  
	test_end testend;	// Handle for the class test_end  
 	gen gen;		// Handle for the class gen 
	Driver drv;	// Handle for the class calc_driver  
	monitor mon;	// Handle for the class calc_monitor 
	scoreboard scb;		// Handle for the class scoreboard 
	coverage cov;   // Handle for the class coverage
  
	mailbox #(Transaction) gen2drv, gen2scb, gen2mon; // Mailbox to enable data transfer between generator to driver and driver to scoreboard
	mailbox #(dut_out_A)mon2scb_A;               // Mailbox to enable data transfer between monitor to scoreboard
	mailbox #(dut_out_B)mon2scb_B;               // Mailbox to enable data transfer between monitor to scoreboard
	mailbox #(dut_out_C)mon2scb_C;               // Mailbox to enable data transfer between monitor to scoreboard
	mailbox #(dut_out_D)mon2scb_D;               // Mailbox to enable data transfer between monitor to scoreboard
  
	virtual calc_if cif; // Virtual interface to calc.
	// Constructor:
	function new(virtual calc_if cif);
    
		this.cif = cif;
		gen2drv = new();	// create new objects
		gen2scb = new();    // create new objects
		gen2mon = new();    // create new objects
		mon2scb_A = new();    // create new objects
		mon2scb_B = new();
		mon2scb_C = new();
		mon2scb_D = new();
		testend = new();    // create new objects
		
		if (!testend.randomize()) // If randomization failed then print error
		begin
			$display("testend::randomize failed");
			$finish;
		end

		gen      = new(gen2drv,gen2scb,gen2mon, testend.trans_cnt, 1);
		drv      = new(this.cif, gen2drv, 1);
		mon      = new(this.cif, mon2scb_A,mon2scb_B,mon2scb_C,mon2scb_D,gen2mon);
		scb      = new(testend.trans_cnt, gen2scb, mon2scb_A,mon2scb_B,mon2scb_C,mon2scb_D);
		cov      = new();

	endfunction: new
	
	virtual task pre_test();	// Virtual function to make sure the same # of transactions are expected by the scoreboard
		scb.max_trans_cnt = gen.max_trans_cnt;
		fork
			drv.main();
			mon.main();
			scb.main();
		join_none
	endtask: pre_test

	virtual task test();	// Virtual function to reset driver and perform the generation operation.
		drv.reset();
		fork
			gen.main();
		join_none
	endtask: test

	virtual task post_test();
		fork
			wait(gen.ended.triggered);
			wait(scb.ended.triggered);
		join
	endtask: post_test

	task run();
		pre_test();
		test();
		post_test();
	endtask: run

endclass: env


// --------------------------------------------------------------------------
// End of env.sv
// --------------------------------------------------------------------------