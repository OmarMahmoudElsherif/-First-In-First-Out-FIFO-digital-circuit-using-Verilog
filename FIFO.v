
module FIFO #(parameter ADDR_WIDTH = 2,parameter DATA_WIDTH = 8) (
	output reg [DATA_WIDTH:0] data_out,	
	input [DATA_WIDTH-1:0] data_in,
	input clk_read,
	//input Async_Reset,
	input clk_write,
	input Wr_enable,
	input Read_enable
	//output empty_flg_out,full_flg_out,
	
	);

// empty_flag : to avoid read when FIFO is Empty
// full_flag : to avoid Write when FIFO is Full
reg empty_flag=1,full_flag=0;
integer i;

//assign empty_flg_out = empty_flag;
//assign full_flg_out = full_flag;

reg [ADDR_WIDTH-1:0] Write_pointer=0, Read_pointer=0;

// Memory inside FIFO
reg [DATA_WIDTH-1:0] FIFO_Memory [0:2**ADDR_WIDTH-1];

// Counters to check the case of Circular Write/Read
reg Write_overflow=0,Read_overflow=0;

// Counters to know if FIFO is full or empty
// where at each write it increment and each Read it decrement
reg [2**ADDR_WIDTH-1:0] counter=0;

//calculate the Flags
always @(counter or Wr_enable or Read_enable) begin

	if(counter == 2**ADDR_WIDTH  ) 
		full_flag <= 1;
	else if (counter == 0)
		empty_flag <= 1;
	else begin
		full_flag<=0;
		empty_flag <=0;
	end
end



// Read Operation
always @(posedge clk_read ) begin
	//if(Async_Reset) begin	
	//	Read_overflow <= 0;
	//	Read_pointer <= 0;
	//	counter <= 0;
	//	empty_flag <=0;
	//	for(i=0;i<2**ADD_WIDTH;i=i+1)
	//		FIFO_Memory[i] <= 0;
	//end
	if( Read_enable && (!empty_flag) )  begin
		data_out <= FIFO_Memory[Read_pointer]; //  Circular Read
		{Read_overflow,Read_pointer} <= {Read_overflow,Read_pointer} + 1;
		//empty_flag <= 0;
		if(counter!=0) begin
			counter <= counter - 1;
		end
	end

end

// Write Operation
always @(posedge clk_write ) begin
	//if(Async_Reset) begin
	//	Write_overflow <= 0;	 
	//	Write_pointer <= 0;
	//	counter <= 0;
	//	full_flag <=0;
	//	for(i=0;i<2**ADD_WIDTH;i=i+1)
	//		FIFO_Memory[i] <= 0;
	//end
	if(  Wr_enable & ~full_flag ) begin
 		 FIFO_Memory[Write_pointer] <= data_in;  //  Circular Write
		{Write_overflow,Write_pointer} <= {Write_overflow,Write_pointer} + 1;
		//full_flag <=0;
		//if(counter <= 2**ADD_WIDTH-1) begin	
			counter <= counter + 1;		
		//end
		
	end

end



endmodule
