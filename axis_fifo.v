`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2024 14:50:44
// Design Name: 
// Module Name: axis_fifo
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


module axis_fifo(
  input wire axis_clk,
  input wire resetn,
  
  //slave pins // receving the data from master
  input wire s_axis_tvalid,
 // output reg s_axis_tready,
  input wire [7:0]s_axis_tdata,
  input wire s_axis_tkeep,
  input wire s_axis_tlast,
  
 // master pins // master sending the data to slave 
  input  wire   m_axis_tready,
   output reg  m_axis_tvalid,
  output  reg [7:0]m_axis_tdata,
  output  reg  m_axis_tkeep,
  output  reg  m_axis_tlast

    );
    
  integer i;
    
  reg [7:0] mem_depth [0:15];
  reg      mem_keep [0:15]; // keep also will check the validity up to memory size
  reg       mem_last [0:15];   // last also assigned the depth as it will enable during the  last byte of data
  reg [4:0] count ;
  // pointer wr and rd pointer
  reg [4:0] wr_ptr;  // write pointer required to point to the next data
  reg [4:0] rd_ptr;  // rd pointer required when m_axis_tready == 1'b1 then consumer read the data
  
  // full and empty signal of fifo
  wire fifo_full;     // count tends to last byte// deasserted during the write part
  wire fifo_empty;  // count  tends to 0 // deasserted during the read part
  
  // assigning the fifo full when the count == last byte of data (as count keep the track of data byte by byte
  
  assign fifo_full = (count == 5'd15) ? 1: 1'b0; // when reaches to last byte of data.
  assign fifo_empty = (count == 5'd0) ? 1: 1'b0;
  
  
  // always block to set the reset logic
  
  always @ (posedge axis_clk) 
  begin
  if (resetn == 1'b0 ) 
  begin
     wr_ptr <= 0;
     rd_ptr <= 0;
     count <= 0;
     // master pin
     m_axis_tvalid <= 1'b0;
     m_axis_tdata <= 0;
     m_axis_tkeep <= 0;
     m_axis_tlast <= 0;
     
     // initialize the memory during reset set to 1'b0
     for (i = 0; i< 16 ; i =  i+1) 
     begin
        mem_depth[i] <= 8'h00;
        mem_keep[i] <= 1'b0;
        mem_last[i] <= 1'b0;
     end  
     
  end
  
  /// assigning the condition based upon slave input
  /*
    update the fifo memory and writing part
   if s_axis_tvalid is enable and fifo_full is low then  slave pins updated to memory contents.
   And wr_ptr will increment
   counter will also increment.
   writing part is done .
  */  
 else if ((s_axis_tvalid == 1'b1) && (fifo_full == 1'b0))  
   begin
      mem_depth[wr_ptr] <= s_axis_tdata;
      mem_keep[wr_ptr] <= s_axis_tkeep;
      mem_last[wr_ptr] <= s_axis_tlast;
      wr_ptr <= wr_ptr + 1;
      count <= count + 1;
     m_axis_tvalid <= 1'b0;
     m_axis_tdata <= 0;
     m_axis_tkeep <= 0;
     m_axis_tlast <= 0;
   end
   
   /* Read data from the FIFO if it's not empty and mux is ready
      Here first scenario is that when m_axis_tready is high the data will be read
      count deccrase during reading the data
    */
    
    else if ((m_axis_tready == 1'b1) && (fifo_empty == 1'b0))  
    begin
        m_axis_tdata <= mem_depth[rd_ptr];
        m_axis_tkeep <= mem_keep[rd_ptr];
        m_axis_tlast <= mem_last[rd_ptr];
         m_axis_tvalid <= 1'b1;
        rd_ptr <= rd_ptr + 1;
        count <= count - 1; 
    end
    
  end

endmodule
