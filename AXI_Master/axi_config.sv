


class master_config extends uvm_object;
	`uvm_object_utils(master_config)
		
	function new(string name="master_config");
		super.new(name);
	endfunction
	
	virtual axi_master_interface vif;
	uvm_active_passive_enum is_active = UVM_ACTIVE;

endclass


