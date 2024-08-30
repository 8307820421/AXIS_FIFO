`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2024 16:30:11
// Design Name: 
// Module Name: axis_fifo_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//`define clk_period 10;

module axis_fifo_tb();

 reg axis_clk ;
 reg  resetn;
  //slave pins // receving the data from master
 reg  s_axis_tvalid;
 reg [7:0]s_axis_tdata;
 reg s_axis_tkeep;
 reg s_axis_tlast;
  
 // master pins // master sending the data to slave 
  reg  m_axis_tready;
  wire  m_axis_tvalid;
  wire [7:0]m_axis_tdata;
  wire  m_axis_tkeep;
  wire  m_axis_tlast;
  
  // Instantiation the module
  
  axis_fifo dut (
 .axis_clk(axis_clk),
 .resetn(resetn),
  //slave pins // receving the data from master
 .s_axis_tvalid(s_axis_tvalid),
 .s_axis_tdata (s_axis_tdata),
 .s_axis_tkeep (s_axis_tkeep),
 .s_axis_tlast(s_axis_tlast),
  
 // master pins // master sending the data to slave 
 .m_axis_tready (m_axis_tready),
 .m_axis_tvalid(m_axis_tvalid),
 .m_axis_tdata (m_axis_tdata),
 .m_axis_tkeep(m_axis_tkeep),
 .m_axis_tlast(m_axis_tlast)
  
  );
  
integer i;
always #10 axis_clk = ~axis_clk;

//reset  stimuli
initial begin
axis_clk = 0;
resetn = 1'b0;
s_axis_tvalid = 1'b0;
s_axis_tdata = 8'h00;
s_axis_tkeep = 1'b0;
s_axis_tlast = 1'b0;
m_axis_tready = 1'b0;
repeat(5) @ (posedge axis_clk);

resetn = 1'b1;
/*
  slave valid  then data will transmit
*/
for (i = 0 ; i< 20; i = i+1) 
begin
@(posedge axis_clk);
  m_axis_tready = 1'b0;
  s_axis_tvalid = 1'b1;
  s_axis_tdata = $random();
  s_axis_tkeep = 1'b1;
  s_axis_tlast = 1'b0;
end

/*
  m_axis_ready high then data will read from fifo // other slave ports get deasserted
*/
for (i = 0 ; i< 20; i = i+1) 
begin
@(posedge axis_clk);
 s_axis_tvalid = 1'b0;
  m_axis_tready = 1'b1;
  s_axis_tdata = 8'h00;
  s_axis_tkeep = 1'b0;
  s_axis_tlast = 1'b0; 
end
 
#10 $finish; 
 end
 
 
endmodule
