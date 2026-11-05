

class master_driver extends uvm_driver#(axi_master_trans);
	`uvm_component_utils(master_driver)

	function new(string name = "master_driver",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	master_config master_cfg;

	//virtual interface handle
	virtual axi_master_interface.MAST_DRV_MP  vif;

	axi_master_trans q1[$],q2[$],q3[$],q4[$],q5[$];

	semaphore sem=new();
	semaphore sem1=new();
	semaphore sem2=new(1); //write address
	semaphore sem3=new(1); //write_data
	semaphore sem4=new(1); // write_response
	semaphore sem5=new(1); 
	semaphore sem6=new(1);
	semaphore sem7=new();

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(axi_master_trans xtn);
	extern task write_address(axi_master_trans xtn);
	extern task write_data(axi_master_trans xtn);
	extern task write_response(axi_master_trans xtn);
	extern task read_address(axi_master_trans xtn);
	extern task read_data(axi_master_trans xtn);

endclass

	function void master_driver :: build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db #(master_config) :: get(this,"","master_config",master_cfg))
			`uvm_error("master_driver","getting interface failed")

	endfunction

	function void master_driver :: connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif=master_cfg.vif;
	endfunction

	task master_driver::run_phase(uvm_phase phase);
		super.run_phase(phase);

		forever
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				seq_item_port.item_done();
			//	$display("Driving completed in Master");
			end
	endtask

	task master_driver :: send_to_dut(axi_master_trans xtn);
		//	`uvm_info(get_type_name(),$sformatf("transaction = %s",xtn.sprint()),UVM_MEDIUM)
			q1.push_back(xtn);
			q2.push_back(xtn);
			q3.push_back(xtn);
			q4.push_back(xtn);
			q5.push_back(xtn);

		      fork
			begin
				sem3.get(1);
			//	$display("before wa in master");
				write_address(q1.pop_front());				
			//	$display("after wa in master");				
				sem.put(1);
				sem3.put(1);
			end

			begin
				sem.get(1);
				sem2.get(1);
			//	$display("before w in master");
				write_data(q2.pop_front());
			//	$display("after w in master");				
				sem1.put(1);
				sem2.put(1);
			end

			begin
				sem1.get(1);
				sem4.get(1);
			//	$display("before b in master");
				write_response(q3.pop_front());
			//	$display("after b in master");				
				sem4.put(1);
			end

			begin
				sem5.get(1);
			//	$display("before ra in master");
				read_address(q4.pop_front());
			//	$display("after ra in master");				
				sem7.put(1);
				sem5.put(1);
			end

			begin
				sem7.get(1);
				sem6.get(1);
			//	$display("before r in master");
				read_data(q5.pop_front());
			//	$display("after r in master");				
				sem6.put(1);
			end

		   join
						
	endtask

	task master_driver :: write_address(axi_master_trans xtn);
		
		vif.mast_drv_cb.AWVALID <= 1'b1;
		vif.mast_drv_cb.AWID <= xtn.AWID;
		vif.mast_drv_cb.AWADDR <= xtn.AWADDR;
		vif.mast_drv_cb.AWLEN <= xtn.AWLEN;
		vif.mast_drv_cb.AWSIZE <= xtn.AWSIZE;
		vif.mast_drv_cb.AWBURST <= xtn.AWBURST;
		vif.mast_drv_cb.AWLOCK <= xtn.AWLOCK;
		vif.mast_drv_cb.AWCACHE <= xtn.AWCACHE;
		vif.mast_drv_cb.AWPROT <= xtn.AWPROT;
		vif.mast_drv_cb.AWQOS <= xtn.AWQOS;
		vif.mast_drv_cb.AWUSER <= xtn.AWUSER;
		@(vif.mast_drv_cb);
	
		wait(vif.mast_drv_cb.AWREADY);
	

		vif.mast_drv_cb.AWVALID <= 1'b0;
		
		repeat($urandom_range(1,5))
			@(vif.mast_drv_cb);
		
	//	`uvm_info(get_type_name(),$sformatf("Displaying data from master driver Drive_Write_Address \n %s",xtn.sprint()),UVM_MEDIUM)
	endtask

	task master_driver :: write_data(axi_master_trans xtn);

	//	$display("AWLEN = %0d",xtn.AWLEN);
		for(int i=0;i<xtn.AWLEN+1;i++)
			begin
				vif.mast_drv_cb.WVALID <= 1'b1;
				vif.mast_drv_cb.WUSER <= xtn.WUSER;
				vif.mast_drv_cb.WDATA <= xtn.WDATA[i];
				vif.mast_drv_cb.WSTRB <= xtn.WSTRB[i];
			//	$display("AWLEN in loop = %0d",xtn.AWLEN);
				if(i == xtn.AWLEN)
					vif.mast_drv_cb.WLAST <= 1'b1;
				else
					vif.mast_drv_cb.WLAST <= 1'b0;
				@(vif.mast_drv_cb);
				wait(vif.mast_drv_cb.WREADY)
				vif.mast_drv_cb.WVALID <= 1'b0;
				vif.mast_drv_cb.WLAST <= 1'b0;
				repeat($urandom_range(1,5))
					@(vif.mast_drv_cb);

			end
	//	`uvm_info(get_type_name(),$sformatf("Displaying data from master driver Drive_Write_Data \n %s",xtn.sprint()),UVM_MEDIUM)
	endtask

	task master_driver :: write_response(axi_master_trans xtn);

		vif.mast_drv_cb.BREADY <= 1'b1;
		@(vif.mast_drv_cb);
		wait(vif.mast_drv_cb.BVALID)
		vif.mast_drv_cb.BREADY <= 1'b0;
		repeat($urandom_range(1,5))
			@(vif.mast_drv_cb);
		
	//	`uvm_info(get_type_name(),$sformatf("Displaying data from master driver Drive_Write_Response \n %s",xtn.sprint()),UVM_MEDIUM)
	endtask
	
	task master_driver :: read_address(axi_master_trans xtn);

		vif.mast_drv_cb.ARVALID <= 1'b1;
		vif.mast_drv_cb.ARID <= xtn.ARID;
		vif.mast_drv_cb.ARADDR <= xtn.ARADDR;
		vif.mast_drv_cb.ARLEN <= xtn.ARLEN;
		vif.mast_drv_cb.ARSIZE <= xtn.ARSIZE;
		vif.mast_drv_cb.ARBURST <= xtn.ARBURST;
		vif.mast_drv_cb.ARLOCK <= xtn.ARLOCK;
		vif.mast_drv_cb.ARCACHE <= xtn.ARCACHE;
		vif.mast_drv_cb.ARPROT <= xtn.ARPROT;
		vif.mast_drv_cb.ARQOS <= xtn.ARQOS;
		vif.mast_drv_cb.ARUSER <= xtn.ARUSER;
	//	q5.push_back(xtn);
		@(vif.mast_drv_cb);
		wait(vif.mast_drv_cb.ARREADY)
		vif.mast_drv_cb.ARVALID <= 1'b0;
		
		repeat($urandom_range(1,5))
			@(vif.mast_drv_cb);
		
	//	`uvm_info(get_type_name(),$sformatf("Displaying data from master driver Drive_Read_Address \n %s",xtn.sprint()),UVM_MEDIUM)
	endtask

	task master_driver::read_data(axi_master_trans xtn);

   		 xtn.read_addr_cal();
   		 xtn.RDATA = new[xtn.ARLEN+1];

   		 for (int i = 0; i < xtn.ARLEN+1; i++) begin

       			 vif.mast_drv_cb.RREADY <= 1'b1;

      			  do begin
          			  @(vif.mast_drv_cb);
       			 end
       			 while (!vif.mast_drv_cb.RVALID);

        		xtn.RDATA[i] = vif.mast_drv_cb.RDATA;

        		vif.mast_drv_cb.RREADY <= 1'b0;

       			 repeat($urandom_range(1,5))
          			  @(vif.mast_drv_cb);
   		 end
		//`uvm_info(get_type_name(),$sformatf("Displaying data from master driver Drive_Read_Data \n %s",xtn.sprint()),UVM_MEDIUM)	
	endtask


