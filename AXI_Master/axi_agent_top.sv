

class axi_master_agent_top extends uvm_env;
	`uvm_component_utils(axi_master_agent_top)
	master_agent master_agent_h[];
	env_config env_cfg;
	master_config master_cfg[];
	function new(string name = "axi_master_agent_top",uvm_component parent = null);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
			`uvm_fatal(get_type_name(),"cant get the env config from test")
		if(env_cfg.has_axi_master_agent)
			begin
				master_agent_h = new[env_cfg.no_of_master_agents];
				foreach(master_agent_h[i])
					begin
						master_agent_h[i] = master_agent::type_id::create($sformatf("master_agent_h[%0d]",i),this);
						uvm_config_db#(master_config)::set(this,$sformatf("master_agent_h[%0d]*",i),"master_config",env_cfg.master_cfg[i]);
					end
			end
	endfunction
endclass
