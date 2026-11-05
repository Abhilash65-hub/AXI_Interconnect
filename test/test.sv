class base_test extends uvm_test;

	`uvm_component_utils(base_test)

	env env_h;
	env_config env_cfg;
	master_config master_cfg[];
	slave_config slave_cfg[];
	reset_config reset_cfg;
	
	bit has_axi_master_agent =1;
	bit has_axi_slave_agent =1;
	bit has_axi_reset_agent =1;
	bit has_scoreboard =1;
	
	int no_of_master_agents =2;
	int no_of_slave_agents =3;


	function new(string name = "base_test",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		env_cfg = env_config::type_id::create("env_cfg");
	
		if(has_axi_master_agent)
			begin
				env_cfg.master_cfg = new[no_of_master_agents];
				master_cfg = new[no_of_master_agents];
				foreach(master_cfg[i])
					begin
						master_cfg[i] = master_config::type_id::create($sformatf("master_cfg[%0d]",i));
						if(!uvm_config_db#(virtual axi_master_interface)::get(this,"",$sformatf("axi_mif_%0d",i),master_cfg[i].vif))
							`uvm_fatal(get_type_name(),"cant get the master interface from top")
						master_cfg[i].is_active = UVM_ACTIVE;
						env_cfg.master_cfg[i] = master_cfg[i];
					end	
			end

		if(has_axi_slave_agent)
			begin
				env_cfg.slave_cfg = new[no_of_slave_agents];
				slave_cfg = new[no_of_slave_agents];
				foreach(slave_cfg[i])
					begin
						slave_cfg[i] = slave_config::type_id::create($sformatf("slave_cfg[%0d]",i));
						if(!uvm_config_db#(virtual axi_slave_interface)::get(this,"",$sformatf("axi_sif_%0d",i),slave_cfg[i].vif))
							`uvm_fatal(get_type_name(),"cant get the slave interface from top")
						slave_cfg[i].is_active = UVM_ACTIVE;
						env_cfg.slave_cfg[i] = slave_cfg[i];
					end	
			end

		if(has_axi_reset_agent)
			begin
				reset_cfg = reset_config::type_id::create("reset_cfg");
				if(!uvm_config_db#(virtual reset_interface)::get(this,"","reset_interface",reset_cfg.vif))
					`uvm_fatal(get_type_name(),"cant get the reset interface from top")
				reset_cfg.is_active = UVM_ACTIVE;
				env_cfg.reset_cfg = reset_cfg;

			end	

		env_cfg.has_axi_master_agent =has_axi_master_agent;
		env_cfg.has_axi_slave_agent =has_axi_slave_agent;
		env_cfg.has_axi_reset_agent =has_axi_reset_agent;
		env_cfg.has_scoreboard =has_scoreboard;

		env_cfg.no_of_master_agents =no_of_master_agents;
		env_cfg.no_of_slave_agents =no_of_slave_agents;

		uvm_config_db#(env_config)::set(this,"*","env_config",env_cfg);

		env_h = env::type_id::create("env_h",this);

	endfunction	

endclass
/*
class test0 extends base_test;

	`uvm_component_utils(test0)

	seqs_r0_w0 seqs_r0_w0_h;

	function new(string name = "test0",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
   	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
			begin
				foreach(env_h.axi_master_agent_top_h.master_agent_h[i])
					begin
						seqs_r0_w0_h = seqs_r0_w0::type_id::create($sformatf("seqs_r0_w0_h[%0d]",i));
						seqs_r0_w0_h.start(env_h.axi_master_agent_top_h.master_agent_h[i].seqr_h);
					end
			end	
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass

class test1 extends base_test;

	`uvm_component_utils(test1)

	seqs_r2_w1 seqs_r2_w1_h;
	seqs_r1_w0 seqs_r1_w0_h;

	function new(string name = "test1",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
   	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
			begin
						seqs_r2_w1_h = seqs_r2_w1::type_id::create("seqs_r2_w1_h[0]");
						seqs_r1_w0_h = seqs_r1_w0::type_id::create("seqs_r1_w0_h[1]");
						seqs_r2_w1_h.start(env_h.axi_master_agent_top_h.master_agent_h[0].seqr_h);
						seqs_r1_w0_h.start(env_h.axi_master_agent_top_h.master_agent_h[1].seqr_h);
			end	
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass

class test2 extends base_test;

	`uvm_component_utils(test2)

	seqs_r0_w2 seqs_r0_w2_h;
	seqs_r1_w2 seqs_r1_w2_h;


	function new(string name = "test2",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
   	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
			begin
						seqs_r0_w2_h = seqs_r0_w2::type_id::create("seqs_r0_w2_h[0]");
						seqs_r1_w2_h = seqs_r1_w2::type_id::create("seqs_r1_w2_h[1]");
						seqs_r0_w2_h.start(env_h.axi_master_agent_top_h.master_agent_h[0].seqr_h);
						seqs_r1_w2_h.start(env_h.axi_master_agent_top_h.master_agent_h[1].seqr_h);
			end	
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass

class test3 extends base_test;

	`uvm_component_utils(test3)

	seqs_r1_w2 seqs_r1_w2_h;
	seqs_r2_w1 seqs_r2_w1_h;


	function new(string name = "test3",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
   	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
			begin
						seqs_r1_w2_h = seqs_r1_w2::type_id::create("seqs_r1_w2_h[0]");
						seqs_r2_w1_h = seqs_r2_w1::type_id::create("seqs_r2_w1_h[1]");
						seqs_r1_w2_h.start(env_h.axi_master_agent_top_h.master_agent_h[0].seqr_h);
						seqs_r2_w1_h.start(env_h.axi_master_agent_top_h.master_agent_h[1].seqr_h);
			end	
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass

class test4 extends base_test;

	`uvm_component_utils(test4)

	seqs_r2_w1 seqs_r2_w1_h;
	seqs_r0_w1 seqs_r0_w1_h;


	function new(string name = "test4",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
   	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
			begin
						seqs_r2_w1_h = seqs_r2_w1::type_id::create("seqs_r2_w1_h[0]");
						seqs_r0_w1_h = seqs_r0_w1::type_id::create("seqs_r0_w1_h[1]");
						seqs_r2_w1_h.start(env_h.axi_master_agent_top_h.master_agent_h[0].seqr_h);
						seqs_r0_w1_h.start(env_h.axi_master_agent_top_h.master_agent_h[1].seqr_h);
			end	
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass

class test5 extends base_test;

	`uvm_component_utils(test5)

	seqs_r1_w0 seqs_r1_w0_h;
	seqs_r2_w2 seqs_r2_w2_h;


	function new(string name = "test5",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
   	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
			begin
						seqs_r1_w0_h = seqs_r1_w0::type_id::create("seqs_r1_w0_h[0]");
						seqs_r2_w2_h = seqs_r2_w2::type_id::create("seqs_r2_w2_h[1]");
						seqs_r1_w0_h.start(env_h.axi_master_agent_top_h.master_agent_h[0].seqr_h);
						seqs_r2_w2_h.start(env_h.axi_master_agent_top_h.master_agent_h[1].seqr_h);
			end	
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass
*/

class test0 extends base_test;

	`uvm_component_utils(test0)

	seqs_r1_w0_F seqs_r1_w0_F_h;
	seqs_r0_w2_F seqs_r0_w2_F_h;


	function new(string name = "test0",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
   	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
			begin
						seqs_r1_w0_F_h = seqs_r1_w0_F::type_id::create("seqs_r1_w0_F_h[0]");
						seqs_r0_w2_F_h = seqs_r0_w2_F::type_id::create("seqs_r0_w2_F_h[1]");
						seqs_r1_w0_F_h.start(env_h.axi_master_agent_top_h.master_agent_h[0].seqr_h);
						seqs_r0_w2_F_h.start(env_h.axi_master_agent_top_h.master_agent_h[1].seqr_h);
			end	
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass

class test1 extends base_test;

	`uvm_component_utils(test1)

	seqs_r1_w0_I seqs_r1_w0_I_h;
	seqs_r0_w2_I seqs_r0_w2_I_h;


	function new(string name = "test1",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
   	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
			begin
						seqs_r1_w0_I_h = seqs_r1_w0_I::type_id::create("seqs_r1_w0_I_h[0]");
						seqs_r0_w2_I_h = seqs_r0_w2_I::type_id::create("seqs_r0_w2_I_h[1]");
						seqs_r1_w0_I_h.start(env_h.axi_master_agent_top_h.master_agent_h[0].seqr_h);
						seqs_r0_w2_I_h.start(env_h.axi_master_agent_top_h.master_agent_h[1].seqr_h);
			end	
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass

class test2 extends base_test;

	`uvm_component_utils(test2)

	seqs_r1_w0_W seqs_r1_w0_W_h;
	seqs_r0_w2_W seqs_r0_w2_W_h;


	function new(string name = "test2",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
   	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
			begin
						seqs_r1_w0_W_h = seqs_r1_w0_W::type_id::create("seqs_r1_w0_W_h[0]");
						seqs_r0_w2_W_h = seqs_r0_w2_W::type_id::create("seqs_r0_w2_W_h[1]");
						seqs_r1_w0_W_h.start(env_h.axi_master_agent_top_h.master_agent_h[0].seqr_h);
						seqs_r0_w2_W_h.start(env_h.axi_master_agent_top_h.master_agent_h[1].seqr_h);
			end	
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass

class test3 extends base_test;

	`uvm_component_utils(test3)

	seqs_r2_w1_F seqs_r2_w1_F_h;
	seqs_r1_w0_F seqs_r1_w0_F_h;


	function new(string name = "test3",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
   	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
			begin
						seqs_r2_w1_F_h = seqs_r2_w1_F::type_id::create("seqs_r2_w1_F_h[0]");
						seqs_r1_w0_F_h = seqs_r1_w0_F::type_id::create("seqs_r1_w0_F_h[1]");
						seqs_r2_w1_F_h.start(env_h.axi_master_agent_top_h.master_agent_h[0].seqr_h);
						seqs_r1_w0_F_h.start(env_h.axi_master_agent_top_h.master_agent_h[1].seqr_h);
			end	
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass

class test4 extends base_test;

	`uvm_component_utils(test4)

	seqs_r2_w1_I seqs_r2_w1_I_h;
	seqs_r1_w0_I seqs_r1_w0_I_h;


	function new(string name = "test4",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
   	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
			begin
						seqs_r2_w1_I_h = seqs_r2_w1_I::type_id::create("seqs_r2_w1_I_h[0]");
						seqs_r1_w0_I_h = seqs_r1_w0_I::type_id::create("seqs_r1_w0_I_h[1]");
						seqs_r2_w1_I_h.start(env_h.axi_master_agent_top_h.master_agent_h[0].seqr_h);
						seqs_r1_w0_I_h.start(env_h.axi_master_agent_top_h.master_agent_h[1].seqr_h);
			end	
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass

class test5 extends base_test;

	`uvm_component_utils(test5)

	seqs_r2_w1_W seqs_r2_w1_W_h;
	seqs_r1_w0_W seqs_r1_w0_W_h;


	function new(string name = "test5",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
   	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
			begin
						seqs_r2_w1_W_h = seqs_r2_w1_W::type_id::create("seqs_r2_w1_W_h[0]");
						seqs_r1_w0_W_h = seqs_r1_w0_W::type_id::create("seqs_r1_w0_W_h[1]");
						seqs_r2_w1_W_h.start(env_h.axi_master_agent_top_h.master_agent_h[0].seqr_h);
						seqs_r1_w0_W_h.start(env_h.axi_master_agent_top_h.master_agent_h[1].seqr_h);
			end	
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass

class test6 extends base_test;

	`uvm_component_utils(test6)

	seqs_r0_w2_F seqs_r0_w2_F_h;
	seqs_r2_w1_F seqs_r2_w1_F_h;


	function new(string name = "test6",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
   	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
			begin
						seqs_r0_w2_F_h = seqs_r0_w2_F::type_id::create("seqs_r0_w2_F_h[0]");
						seqs_r2_w1_F_h = seqs_r2_w1_F::type_id::create("seqs_r2_w1_F_h[1]");
						seqs_r0_w2_F_h.start(env_h.axi_master_agent_top_h.master_agent_h[0].seqr_h);
						seqs_r2_w1_F_h.start(env_h.axi_master_agent_top_h.master_agent_h[1].seqr_h);
			end	
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass

class test7 extends base_test;

	`uvm_component_utils(test7)

	seqs_r0_w2_I seqs_r0_w2_I_h;
	seqs_r2_w1_I seqs_r2_w1_I_h;


	function new(string name = "test7",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
   	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
			begin
						seqs_r0_w2_I_h = seqs_r0_w2_I::type_id::create("seqs_r0_w2_I_h[0]");
						seqs_r2_w1_I_h = seqs_r2_w1_I::type_id::create("seqs_r2_w1_I_h[1]");
						seqs_r0_w2_I_h.start(env_h.axi_master_agent_top_h.master_agent_h[0].seqr_h);
						seqs_r2_w1_I_h.start(env_h.axi_master_agent_top_h.master_agent_h[1].seqr_h);
			end	
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass

class test8 extends base_test;

	`uvm_component_utils(test8)

	seqs_r0_w2_W seqs_r0_w2_W_h;
	seqs_r2_w1_W seqs_r2_w1_W_h;


	function new(string name = "test8",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
   	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
			begin
						seqs_r0_w2_W_h = seqs_r0_w2_W::type_id::create("seqs_r0_w2_W_h[0]");
						seqs_r2_w1_W_h = seqs_r2_w1_W::type_id::create("seqs_r2_w1_W_h[1]");
						seqs_r0_w2_W_h.start(env_h.axi_master_agent_top_h.master_agent_h[0].seqr_h);
						seqs_r2_w1_W_h.start(env_h.axi_master_agent_top_h.master_agent_h[1].seqr_h);
			end	
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass




