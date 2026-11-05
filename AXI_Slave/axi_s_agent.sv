
class slave_agent extends uvm_agent;
	`uvm_component_utils(slave_agent)
	slave_driver drv_h;
	slave_monitor mon_h;
	slave_sequencer seqr_h;
	slave_config slave_cfg; 
	function new(string name = "slave_agent",uvm_component parent = null);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(slave_config)::get(this,"","slave_config",slave_cfg))
			`uvm_fatal(get_type_name(),"cant get the slave config from slave_agent top")
		mon_h = slave_monitor::type_id::create("mon_h",this);
		if(slave_cfg.is_active == UVM_ACTIVE)
			begin
				drv_h = slave_driver::type_id::create("drv_h",this);
				seqr_h = slave_sequencer::type_id::create("seqr_h",this);
			end
	endfunction
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction
endclass


