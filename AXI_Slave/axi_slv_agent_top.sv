
class axi_slave_agent_top extends uvm_env;
	`uvm_component_utils(axi_slave_agent_top)
	slave_agent slave_agent_h[];
	env_config env_cfg;
	slave_config slave_cfg[];
	function new(string name = "axi_slave_agent_top",uvm_component parent = null);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
			`uvm_fatal(get_type_name(),"cant get the env config from test")
		if(env_cfg.has_axi_slave_agent)
			begin
				slave_agent_h = new[env_cfg.no_of_slave_agents];
				foreach(slave_agent_h[i])
					begin
						slave_agent_h[i] = slave_agent::type_id::create($sformatf("slave_agent_h[%0d]",i),this);
						uvm_config_db#(slave_config)::set(this,$sformatf("slave_agent_h[%0d]*",i),"slave_config",env_cfg.slave_cfg[i]);
					end
			end
	endfunction
endclass


