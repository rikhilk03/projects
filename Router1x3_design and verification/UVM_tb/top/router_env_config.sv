//--------**********************************************************************************************************----------
//--------**********************************************************************************************************----------
//--------**************************** Router Environment Configuration ********************************************----------

          class router_env_config extends uvm_object;
              
              `uvm_object_utils(router_env_config)
              source_config s_cfg[];
              destination_config d_cfg[];
              
              int no_of_sagents = 1;
              int no_of_dagents = 3;
              
              function new(string name = "router_env_config");
                  super.new(name);
              endfunction:new
              
          endclass:router_env_config