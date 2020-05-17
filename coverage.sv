package A;
class coverage;
  logic [0:3] reqcmd_a,reqcmd_b,reqcmd_c,reqcmd_d;
  logic [0:31] reqa_dataa_in, reqa_datab_in, reqb_dataa_in, reqb_datab_in,reqc_dataa_in, reqc_datab_in,reqd_dataa_in, reqd_datab_in;
  
 covergroup cg;
   coverpoint reqcmd_a;
   coverpoint reqcmd_b;
   coverpoint reqcmd_c;
   coverpoint reqcmd_d;
   coverpoint reqa_dataa_in;
   coverpoint reqa_datab_in;
   coverpoint reqb_dataa_in;
   coverpoint reqb_datab_in;
   coverpoint reqc_dataa_in;
   coverpoint reqc_datab_in;
   coverpoint reqd_dataa_in;
   coverpoint reqd_datab_in;
 endgroup : cg
  
  function new();
    cg=new;
endfunction : new

function void funcov( reqcmd_a,reqcmd_b,reqcmd_c,reqcmd_d, 
     reqa_dataa_in, reqa_datab_in, reqb_dataa_in, reqb_datab_in,reqc_dataa_in, reqc_datab_in,reqd_dataa_in, reqd_datab_in);
    $display (" Coverage");
    this.reqcmd_a=reqcmd_a;
    this.reqcmd_b=reqcmd_b;
    this.reqcmd_c=reqcmd_c;
    this.reqcmd_d=reqcmd_d;
    this.reqa_dataa_in=reqa_dataa_in;
    this.reqa_datab_in=reqa_datab_in;
    this.reqb_dataa_in=reqb_dataa_in;
    this.reqb_datab_in=reqb_datab_in;
    this.reqc_dataa_in=reqc_dataa_in;
    this.reqc_datab_in=reqc_datab_in;
    this.reqd_dataa_in=reqd_dataa_in;
    this.reqd_datab_in=reqd_datab_in;  
  cg.sample;
 endfunction : funcov
endclass : coverage
endpackage : A
