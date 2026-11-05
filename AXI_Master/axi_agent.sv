class master_agent extends uvm_agent;
	`uvm_component_utils(master_agent)
	master_driver drv_h;
	master_monitor mon_h;
	master_sequencer seqr_h;
	master_config master_cfg; 
	function new(string name = "master_agent",uvm_component parent = null);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(master_config)::get(this,"","master_config",master_cfg))
			`uvm_fatal(get_type_name(),"cant get the master config from agent top")
		mon_h = master_monitor::type_id::create("mon_h",this);
		if(master_cfg.is_active == UVM_ACTIVE)
			begin
				drv_h = master_driver::type_id::create("drv_h",this);
				seqr_h = master_sequencer::type_id::create("seqr_h",this);
			end
	endfunction
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		if(master_cfg.is_active == UVM_ACTIVE)
			begin
				drv_h.seq_item_port.connect(seqr_h.seq_item_export);
			end

	endfunction
endclass


