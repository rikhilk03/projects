///**********************************************************************************************************************///
///**********************************************************************************************************************///
///************************************************router interface******************************************************///

          interface router_if(input bit clk);
              logic rst;
              logic pkt_valid;
              logic err;
              logic busy;
              logic valid_out;
              logic read_enb;
              logic [7:0]data_in;
              logic [7:0]data_out;
              
              // Clocking block for source driver
              clocking source_drv@(posedge clk);
                  
                  default input #1 output #1;// input skew and output skew
                  
                  output rst,pkt_valid,data_in;/////////doubt
                  input busy,err;
                  
              endclocking:source_drv
              
              // Clocking block for source monitor
              clocking source_mon@(posedge clk);
                  
                  default input #1 output #1;// input skew and output skew
                  
                  input rst,pkt_valid,data_in,busy,err;
                  
              endclocking:source_mon
              
              // Clocking block for destination driver
              clocking destination_drv@(posedge clk);
              
                  default input #1 output #1; // input skew and output skew
                  
                  output read_enb;/////////////////doubt sould be output
                  input valid_out;
              endclocking:destination_drv
              
              //Clocking block for destnation monitor
              clocking destination_mon@(posedge clk);
              
                  default input #1 output #1; // input skew and output skew
                  
                  //output valid_out;
                  input valid_out,read_enb,data_out;///////////////////doubt
              endclocking:destination_mon
              
              //Source Driver Modport
              modport SOURCE_DRV (clocking source_drv);
              
              // Source Monitor Modport
              modport SOURCE_MON (clocking source_mon);
              
              //Destination Driver modport
              modport DESTINATION_DRV (clocking destination_drv);
              
              //Destination Monitor Modport
              modport DESTINATION_MON (clocking destination_mon);

          endinterface:router_if
