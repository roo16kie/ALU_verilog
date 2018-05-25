
module Adder_4(sum,c_out,v,a,b,ctr);

	input [3:0]a ,b ;
	input ctr;
	output reg [3:0]sum ;
	output reg c_out,v;
	reg [3:0]kiwi;
	reg [2:0]pig;

	always @(a or b or ctr)
		begin
			kiwi[0] = b[0] ^ ctr ;
			kiwi[1] = b[1] ^ ctr ;
			kiwi[2] = b[2] ^ ctr ;
			kiwi[3] = b[3] ^ ctr ;
			pig[0] = (a[0]^kiwi[0]) * ctr + a[0]*kiwi[0] ;
			pig[1] = (a[1]^kiwi[1]) * pig[0] + a[1] * kiwi[1] ;
			pig[2] = (a[2]^kiwi[2]) * pig[1] + a[2] * kiwi[2] ;
			c_out = (a[3]^kiwi[3]) * pig[2] + a[3] * kiwi[3] ;
			sum[0] = a[0]^kiwi[0]^ctr;
			sum[1] = a[1]^kiwi[1]^pig[0];
			sum[2] = a[2]^kiwi[2]^pig[1];
			sum[3] = a[3]^kiwi[3]^pig[2];
	
	
				v = pig[2] ^ c_out ;

		end
	
endmodule	


module alu (overflow,alu_out,zero,src_a,src_b,opcode,clk,reset) ;


output overflow,zero ;
output [3:0]alu_out ;
input[3:0] src_a,src_b;
input[2:0]opcode ;
input clk, reset;
reg [3:0]alu_out ;
reg zero , overflow ;
wire fuck0,fuck1 ;
wire [3:0]fruit0 , fruit1;
wire co0 , co1;

Adder_4 pig(fruit0,co0,fuck0,src_a,src_b,opcode[0]);
Adder_4 kiwi(fruit1,co1,fuck1,src_a,src_b,opcode[0]);

always@(posedge clk)
	begin
		if (reset==1)
		begin alu_out=4'b0000 ; overflow=1'b0 ; zero=1'b1 ; end
		else if(opcode==3'b000)
		begin
			alu_out = 4'd0 ; zero = 1'b1 ; overflow = 1'b0 ;
		end
		else if (opcode==3'b001)
		begin
			alu_out = src_a & src_b ;  overflow = 1'b0 ;
			if (alu_out==4'b0000)
			begin zero=1'b1; end
			else zero=1'b0;
		end
		else if (opcode==3'b010)
		begin
			alu_out = src_a | src_b ;  overflow = 1'b0 ;
			if (alu_out==4'b0000)
			begin zero=1'b1; end
			else zero=1'b0;
		end
		else if (opcode==3'b011)
		begin
			if(src_a==0000)
			begin
				alu_out = src_a ; zero = 1'b1 ; overflow = 1'b0 ;
			end
			else
			begin
				alu_out = src_a ; zero = 1'b0 ; overflow = 1'b0 ;
			end
		end
		else if (opcode==3'b100)
		begin
			overflow = fuck0 ;
			alu_out = fruit0 ;
			if (fruit0==4'b0000)
			begin
				zero = 1'b1;
			end
			else
			begin
				zero = 1'b0;
			end
		end
		else if (opcode==3'b101)
		begin
			overflow = fuck1 ;
			alu_out = fruit1 ;
			if (fruit1==4'b0000)
			begin
				zero = 1'b1;
			end
			else
			begin
				zero = 1'b0;
			end

		end
		else if (opcode==3'b110)
		begin
			alu_out = src_a >> src_b ;
			
			if (alu_out==4'b0000)
				begin zero = 1'b1 ; overflow = 1'b0 ; end
			else 
				begin zero = 1'b0 ; overflow = 1'b0 ; end
		end
		else if (opcode==3'b111)
		begin
			alu_out = src_a << src_b;
			if (alu_out==4'b0000)
				begin zero = 1'b1 ; overflow = 1'b0 ; end
			else 
				begin zero = 1'b0 ; overflow = 1'b0 ;	end				
		end
	end



endmodule
