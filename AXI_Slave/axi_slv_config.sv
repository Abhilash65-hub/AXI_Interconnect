
class slave_config extends uvm_object;
	`uvm_object_utils(slave_config)
		
	function new(string name="slave_config");
		super.new(name);
	endfunction
	
	virtual axi_slave_interface vif;
	uvm_active_passive_enum is_active = UVM_ACTIVE;

endclass


