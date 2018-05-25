//#######################################################################################
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
 * Software             :Simulation with ncverilog
 * File                 :ALU.v
 * Author               :Chia-Yang Lin
 * School               :Department of Engineering Science , NCKU
 * Date                 :2011/07/15
 * Lab                  :VLSI signal processing LAB @ LAB 41206 
 * Version              :1
 * Abstract             :
 * Modification History :    
			 

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//#######################################################################################*/


`define DATA_NUM 509
`define CYCLE 10
`define PATTERN "pattern_in.txt"
`define EXPECT "alu_out.txt"
`timescale 1ns/10ps

module testfixture ;

reg [2:0] opcode;

reg [3:0] src_a ,src_b ; 

reg clk,reset ;

wire [3:0]alu_out ;

wire overflow,zero ;

reg [10:0]pattern_in[0:`DATA_NUM-1] ;

reg [5:0]ans[0:`DATA_NUM-1] ;


reg overflow_exp,zero_exp ;

reg [3:0] alu_out_exp ;

alu u_alu (	.overflow(overflow),
			.alu_out(alu_out),
			.zero(zero),
			.src_a(src_a),
			.src_b(src_b),
			.opcode(opcode),
			.clk(clk),
			.reset(reset)
) ;

always begin #(`CYCLE/2) clk=~clk ; end  //clock generation

initial begin
$readmemb(`PATTERN,pattern_in) ;
$readmemb(`EXPECT,ans) ;
end


integer i ,err ,check;

initial begin
clk=1'b0 ;
err=0 ;
check=0;
@(negedge clk) reset=1'b1 ;
#(`CYCLE*2) reset=1'b0 ;

@(negedge clk) ;

  for(i=0;i<`DATA_NUM;i=i+1) begin
    {opcode,src_a,src_b}=pattern_in[i] ;
    {alu_out_exp,overflow_exp,zero_exp}=ans[i] ;
    @(negedge clk) ;
//@(posedge clk) ;
    if(alu_out!=alu_out_exp||overflow!=overflow_exp||zero!=zero_exp) begin
    err=err+1 ;
    $display($time,"Error at opcode=%b, src_a=%b, src_b=%b",opcode,src_a,src_b) ;
    $display($time,"Expect   : alu_out=%b, overflow=%b, zero=%b",alu_out_exp,overflow_exp,zero_exp) ;
    $display($time,"Your ans : alu_out=%b, overflow=%b, zero=%b\n\n",alu_out,overflow,zero) ;	
	

    end
    else if(alu_out==alu_out_exp&&overflow==overflow_exp&&zero==zero_exp) check=check+1;
  end
end



initial
begin
   $dumpfile("alu.vcd");
   $dumpvars;
end


initial begin

#(`CYCLE*100) 
if((err==0)&&(check==96)) begin
$display("-------------------   ALU check successfully   -------------------");
$display("            $$              ");
$display("           $  $");
$display("           $  $");
$display("          $   $");
$display("         $    $");
$display("$$$$$$$$$     $$$$$$$$");
$display("$$$$$$$              $");
$display("$$$$$$$              $");
$display("$$$$$$$              $");
$display("$$$$$$$              $");
$display("$$$$$$$              $");
$display("$$$$$$$$$$$$         $$");
$display("$$$$$      $$$$$$$$$$");
end
else if((err==0)&&(check!=96)) begin
$display("-----------   Oops! Something wrong with your code!   ------------");
end
else $display("-------------------   There are %d errors   -------------------", err);
$finish ;

end

endmodule


