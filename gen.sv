// Project		: COEN 6541 - CALC 2
// File Name	: gen.sv
// Description	: The generator is a part of the environment. This is used to breakdown 
// a scenario into high level commands.
//
// --------------------------------------------------------------------------

// Include the transaction file: 
`include "env/Transaction.sv"
import A::coverage;

// Class Generator: 
class gen;
	
	// Handle for the class transaction: 
	rand Transaction rand_tr;
  
	int max_trans_cnt;
	int trans_cnt = 0;
	bit verbose;
	event ended;

  coverage cov;   // Handle for the class coverage

	mailbox #(Transaction) gen2drv,gen2scb,gen2mon; // Mailbox to send data from generator to driver. 

	// Constructor: 
	function new(mailbox #(Transaction) gen2drv,mailbox #(Transaction) gen2scb,mailbox #(Transaction) gen2mon, int max_trans_cnt, bit verbose = 0, int trans_cnt = 0);
  
		rand_tr = new();
		cov=new();
		this.gen2drv = gen2drv;
        this.gen2scb = gen2scb;
		this.gen2mon = gen2mon;
		this.verbose = verbose;
		this.max_trans_cnt = max_trans_cnt;

	endfunction

	// Main Task:
	task main();

		if(verbose)
			$display ($time," : max transaction count = %d \n", max_trans_cnt);

		while(!end_of_test()) 
		begin
			Transaction my_tr;
			my_tr = get_Transaction();

      cov.funcov( my_tr.reqcmd_a,my_tr.reqcmd_b,my_tr.reqcmd_c,my_tr.reqcmd_d, 
     my_tr.reqa_dataa_in, my_tr.reqa_datab_in, my_tr.reqb_dataa_in, my_tr.reqb_datab_in,my_tr.reqc_dataa_in, my_tr.reqc_datab_in,my_tr.reqd_dataa_in, my_tr.reqd_datab_in);
			if (verbose)
				$display($time," : generator transaction count no. %d", trans_cnt);


			gen2drv.put(my_tr); 			// Send the value to the driver. 
			my_tr.print_trans("generator"); // Print the values sent to the driver. 
            gen2scb.put(my_tr);     		// Send values to scoreboard
			gen2mon.put(my_tr);				// Send count to monitor.
            my_tr.print_trans("generator to scoreboard"); // Print the values sent to the scoreboard
			trans_cnt++;					// Increment the count of transaction. 
		end

		if (verbose)
			$display($time," : ending generator\n");
			->ended;
	endtask

	// Virtual function to mark the end of the test: 
	virtual function bit end_of_test();
		end_of_test = trans_cnt>=max_trans_cnt;
	endfunction

	// Virtual function to get the data:
	virtual function Transaction get_Transaction();
		rand_tr.trans_cnt = trans_cnt;
		rand_tr.reset = 1'b0;
	   
if (!(this.rand_tr.randomize() with {reqa_datab_in inside {32'h00000000, 32'hFFFFFFFF};}))
		begin
			$display("randomize failed");
			$finish;
		end
		
rand_tr.reset = 1'b0;
		return rand_tr.copy();
 
		if(--max_trans_cnt<1) begin
			-> ended;
		end 
	endfunction

endclass

 
// --------------------------------------------------------------------------
// End of gen.sv
// -------------------------------------------------------------------------- 

  