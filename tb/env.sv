class env extends uvm_env;
	`uvm_component_utils(env)
	function new(string name = "env",uvm_component parent = null);
		super.new(name,parent);
	endfunction
	sb sb_h;
	axi_master_agent_top axi_master_agent_top_h;
	axi_slave_agent_top axi_slave_agent_top_h;
	axi_reset_agent_top axi_reset_agent_top_h;
	env_config env_cfg;
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
			`uvm_fatal(get_type_name(),"cant get the env_config from test")
		if(env_cfg.has_scoreboard)
			sb_h = sb::type_id::create("sb_h",this);
		axi_master_agent_top_h  = axi_master_agent_top::type_id::create("axi_master_agent_top_h",this);
		axi_slave_agent_top_h  = axi_slave_agent_top::type_id::create("axi_slave_agent_top_h",this);
		axi_reset_agent_top_h  = axi_reset_agent_top::type_id::create("axi_reset_agent_top_h",this);
	endfunction
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(env_cfg.has_scoreboard)
			begin
				axi_reset_agent_top_h.reset_agent_h.mon_h.monitor_port.connect(sb_h.reset_fifo.analysis_export);
				foreach(axi_master_agent_top_h.master_agent_h[i])
					begin
						axi_master_agent_top_h.master_agent_h[i].mon_h.monitor_port.connect(sb_h.master_fifo[i].analysis_export);
					end
				foreach(axi_slave_agent_top_h.slave_agent_h[i])					
					begin
						axi_slave_agent_top_h.slave_agent_h[i].mon_h.monitor_port.connect(sb_h.slave_fifo[i].analysis_export);
					end
			end

	endfunction
endclass









