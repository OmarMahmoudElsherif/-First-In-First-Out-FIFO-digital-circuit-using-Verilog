
`timescale 10ps/10ps
module FIFO_TB();

parameter ADDR_WIDTH = 2;
parameter DATA_WIDTH = 8;

parameter clk_read_prd = 10;
parameter clk_write_prd = 5;

reg [DATA_WIDTH-1:0] data_in;
reg clk_read=0;
//reg Async_Reset;
reg clk_write=0;
reg Write_enable;
reg Read_enable;
wire [DATA_WIDTH:0] data_out;
//wire full_flag,empty_flag;

always #(clk_write_prd) clk_write =~clk_write;
always #(clk_write_prd) clk_read =~clk_read;


FIFO #(.ADDR_WIDTH(ADDR_WIDTH),.DATA_WIDTH(DATA_WIDTH)) fifo_dut (
	.data_in(data_in),
	.clk_read(clk_read),
	//.Async_Reset(Async_Reset),
	.clk_write(clk_write),
	.Wr_enable(Write_enable),
	.Read_enable(Read_enable),
	//.empty_flg_out(empty_flag),
	//.full_flg_out(full_flag),
	.data_out(data_out)
);


// Task to Write Data in FiFo
task write_data (
	input [DATA_WIDTH-1:0] data_in_tb
);
begin
Write_enable <= 1;
data_in <= data_in_tb;
#(clk_write_prd*2);
$display("Writing value : %d",data_in);

Write_enable <=0;
end
endtask

// Task to Read Data in FiFo
task Read_data (
);
begin
Read_enable <= 1;
#(clk_write_prd*2);
#1 $display("Reading value: %d",data_out);

Read_enable <= 0;
end
endtask


initial begin

// reset the FIFO
//Async_Reset =1;
//#(clk_write_prd);
///Async_Reset =0;


//Reading From Empty FiFo
Read_data();   // Empty FIFO
//if(empty_flag==1)
$display("FIFO is Now Empty");

// Writing 2 values in FIFO
write_data(8'd5);
write_data(8'd8);
//if(full_flag == 1)
$display("FIFO in Now FULL"); 

// Reading 2 values from FIFO
Read_data();
Read_data();
//if(empty_flag==1)
$display("FIFO is Now Empty");

// Writing all values in FIFO
write_data(8'd5);
write_data(8'd8);
write_data(8'd10);
write_data(8'd12);
//if(full_flag == 1)
$display("FIFO in Now FULL"); // FIFO is FULL


end


endmodule
