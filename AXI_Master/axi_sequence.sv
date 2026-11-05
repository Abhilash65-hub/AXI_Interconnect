

class base_seqs extends uvm_sequence#(axi_master_trans);
	`uvm_object_utils(base_seqs)

	function new(string name = "base_seqs");
		super.new(name);
	endfunction
endclass
/*
class seqs_r0_w0 extends base_seqs;
	`uvm_object_utils(seqs_r0_w0)

	function new(string name = "seqs_r0_w0");
		super.new(name);
	endfunction
	task body();
	repeat(1)
		begin
			req = axi_master_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {read_slave == 1;
						   write_slave == 0;});
			finish_item(req);
		end
	endtask
endclass

class seqs_r1_w2 extends base_seqs;
	`uvm_object_utils(seqs_r1_w2)

	function new(string name = "seqs_r1_w2");
		super.new(name);
	endfunction
	task body();
	repeat(1)
		begin
			req = axi_master_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {read_slave == 1;
						   write_slave == 2;});
			finish_item(req);
		end
	endtask
endclass

class seqs_r2_w1 extends base_seqs;
	`uvm_object_utils(seqs_r2_w1)

	function new(string name = "seqs_r2_w1");
		super.new(name);
	endfunction
	task body();
	repeat(1)
		begin
			req = axi_master_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {read_slave == 2;
						   write_slave == 1;});
			finish_item(req);
		end
	endtask
endclass

class seqs_r1_w0 extends base_seqs;
	`uvm_object_utils(seqs_r1_w0)

	function new(string name = "seqs_r1_w0");
		super.new(name);
	endfunction
	task body();
	repeat(1)
		begin
			req = axi_master_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {read_slave == 1;
						   write_slave == 0;});
			finish_item(req);
		end
	endtask
endclass

class seqs_r0_w2 extends base_seqs;
	`uvm_object_utils(seqs_r0_w2)

	function new(string name = "seqs_r0_w2");
		super.new(name);
	endfunction
	task body();
	repeat(1)
		begin
			req = axi_master_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {read_slave == 0;
						   write_slave == 2;});
			finish_item(req);
		end
	endtask
endclass

class seqs_r0_w1 extends base_seqs;
	`uvm_object_utils(seqs_r0_w1)

	function new(string name = "seqs_r0_w1");
		super.new(name);
	endfunction
	task body();
	repeat(1)
		begin
			req = axi_master_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {read_slave == 0;
						   write_slave == 1;});
			finish_item(req);
		end
	endtask
endclass

class seqs_r2_w2 extends base_seqs;
	`uvm_object_utils(seqs_r2_w2)

	function new(string name = "seqs_r2_w2");
		super.new(name);
	endfunction
	task body();
	repeat(1)
		begin
			req = axi_master_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {read_slave == 2;
						   write_slave == 2;});
			finish_item(req);
		end
	endtask
endclass
*/
class seqs_r1_w0_F extends base_seqs;
	`uvm_object_utils(seqs_r1_w0_F)

	function new(string name = "seqs_r1_w0_F");
		super.new(name);
	endfunction
	task body();
	repeat(1)
		begin
			req = axi_master_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {read_slave == 1;  write_slave == 0; AWBURST == 0;ARBURST == 0; });
			
        
			finish_item(req);
		end
	endtask
endclass
class seqs_r2_w1_F extends base_seqs;
	`uvm_object_utils(seqs_r2_w1_F)

	function new(string name = "seqs_r2_w1_F");
		super.new(name);
	endfunction
	task body();
	repeat(1)
		begin
			req = axi_master_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {read_slave == 2;
						   write_slave == 1;
						   AWBURST == 0;
						   ARBURST == 0;});
			finish_item(req);
		end
	endtask
endclass
class seqs_r0_w2_F extends base_seqs;
	`uvm_object_utils(seqs_r0_w2_F)

	function new(string name = "seqs_r0_w2_F");
		super.new(name);
	endfunction
	task body();
	repeat(1)
		begin
			req = axi_master_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {read_slave == 0;
						   write_slave == 2;
						   AWBURST == 0;
						   ARBURST == 0;});
			finish_item(req);
		end
	endtask
endclass
class seqs_r1_w0_I extends base_seqs;
	`uvm_object_utils(seqs_r1_w0_I)

	function new(string name = "seqs_r1_w0_I");
		super.new(name);
	endfunction
	task body();
	repeat(1)
		begin
			req = axi_master_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {read_slave == 1;
						   write_slave == 0;
						   AWBURST == 1;
						   ARBURST == 1;});
			finish_item(req);
		end
	endtask
endclass
class seqs_r2_w1_I extends base_seqs;
	`uvm_object_utils(seqs_r2_w1_I)

	function new(string name = "seqs_r2_w1_I");
		super.new(name);
	endfunction
	task body();
	repeat(1)
		begin
			req = axi_master_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {read_slave == 2;
						   write_slave == 1;
						   AWBURST == 1;
						   ARBURST == 1;});
			finish_item(req);
		end
	endtask
endclass
class seqs_r0_w2_I extends base_seqs;
	`uvm_object_utils(seqs_r0_w2_I)

	function new(string name = "seqs_r0_w2_I");
		super.new(name);
	endfunction
	task body();
	repeat(1)
		begin
			req = axi_master_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {read_slave == 0;
						   write_slave == 2;
						   AWBURST == 1;
						   ARBURST == 1;});
			finish_item(req);
		end
	endtask
endclass
class seqs_r1_w0_W extends base_seqs;
	`uvm_object_utils(seqs_r1_w0_W)

	function new(string name = "seqs_r1_w0_W");
		super.new(name);
	endfunction
	task body();
	repeat(1)
		begin
			req = axi_master_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {read_slave == 1;
						   write_slave == 0;
						   AWBURST == 2;
						   ARBURST == 2;});
			finish_item(req);
		end
	endtask
endclass
class seqs_r2_w1_W extends base_seqs;
	`uvm_object_utils(seqs_r2_w1_W)

	function new(string name = "seqs_r2_w1_W");
		super.new(name);
	endfunction
	task body();
	repeat(1)
		begin
			req = axi_master_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {read_slave == 2;
						   write_slave == 1;
						   AWBURST == 2;
						   ARBURST == 2;});
			finish_item(req);
		end
	endtask
endclass
class seqs_r0_w2_W extends base_seqs;
	`uvm_object_utils(seqs_r0_w2_W)

	function new(string name = "seqs_r0_w2_W");
		super.new(name);
	endfunction
	task body();
	repeat(1)
		begin
			req = axi_master_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {read_slave == 0;
						   write_slave == 2;
						   AWBURST == 2;
						   ARBURST == 2;});
			finish_item(req);
		end
	endtask
endclass



