# AXIS_FIFO :- 
The AXIS FIFO is one of the important data structure that is used in ethernet based communication system. Here, to track the data and its validity based upon tkeep it is very efficient.

#Problem Statement : Design a FIFO using AXIS interface for ehternet communication to transmit the data to data buffer.

# Consideration :- The first consideration is that :
            1) There is block called data consumer that accept the data from axis fifo when tready of master_axis is high and data will be read. This is the first way to implement the 
             axis FIFO. The rd_ptr plays an important role for this.


# Waveform :
      The first screenshot not related to fifo.
      The secondscreenshot is is to observing the waveform of slave_axis how it is working if it receive the data from data generator block.
      The third Screenshot is also related to check the status of memory depth when (i==15) up to that index data will be write into the memory.
      The fourth screenshot is related to master_axis that will read the data when fifo_full signal is asserted.
      The fifth screenshot represent the complete mechanism of AXIS FIFO in single waveform or single module.

      
             
