class env_config extends uvm_object;
	`uvm_object_utils(env_config)
		
	function new(string name="env_config");
		super.new(name);
	endfunction

	bit has_axi_master_agent =1;
	bit has_axi_slave_agent =1;
	bit has_axi_reset_agent =1;
	bit has_scoreboard =1;

	int no_of_master_agents =2;
	int no_of_slave_agents =3;
	int no_of_scoreboards =1;

	master_config master_cfg[];
	slave_config slave_cfg[];
	reset_config reset_cfg;

endclass


