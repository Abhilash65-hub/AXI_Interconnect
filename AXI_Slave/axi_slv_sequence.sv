
class slave_seqs extends uvm_sequence#(axi_master_trans);
	`uvm_object_utils(slave_seqs)

	function new(string name = "slave_seqs");
		super.new(name);
	endfunction
	virtual task body();
	repeat(1)
		begin
			req = axi_master_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize());
			finish_item(req);
		end
	endtask
endclass

