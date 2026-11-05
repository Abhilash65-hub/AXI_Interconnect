
class slave_driver extends uvm_driver#(axi_master_trans);
	`uvm_component_utils(slave_driver)

	function new(string name = "slave_driver",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	slave_config slave_cfg;

	//virtual interface handle
	virtual axi_slave_interface.SLV_DRV_MP vif;

	axi_master_trans q1[$],q2[$],q3[$];

	int w_mem[*];

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
	extern task send_to_dut();
	extern task write_address();
	extern task write_data(axi_master_trans xtn1);
	extern task write_response(axi_master_trans xtn1);
	extern task read_address();
	extern task read_data(axi_master_trans xtn4);

endclass

	function void slave_driver :: build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db #(slave_config) :: get(this,"","slave_config",slave_cfg))
			`uvm_error("slave_driver","getting interface failed")

	endfunction

	function void slave_driver :: connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif=slave_cfg.vif;
	endfunction

	task slave_driver::run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever
			begin
				send_to_dut();
			//	$display("Driving completed in Slave");
			end
	endtask

	task slave_driver :: send_to_dut();
		      fork
			begin
				sem3.get(1);
			//	$display("before wa in slave");
				write_address();
			//	$display("after wa in slave");				
				sem.put(1);
				sem3.put(1);
			end

			begin
				sem.get(1);
				sem2.get(1);
			//	$display("before w in slave");
				write_data(q1.pop_front());
			//	$display("after w in slave");				
				sem1.put(1);
				sem2.put(1);
			end

			begin
				sem1.get(1);
				sem4.get(1);
			//	$display("before b in slave");
				write_response(q3.pop_front());
			//	$display("after b in slave");				
				sem4.put(1);
			end

			begin
				sem5.get(1);
			//	$display("before ra in slave");
				read_address();
			//	$display("after ra in slave");				
				sem7.put(1);
				sem5.put(1);
			end

			begin
				sem7.get(1);
				sem6.get(1);
			//	$display("before r in slave");
				read_data(q2.pop_front());
			//	$display("after r in slave");				
				sem6.put(1);
			end

		   join					
	endtask

	task slave_driver :: write_address();

		axi_master_trans xtn1;
		xtn1 = axi_master_trans::type_id::create("xtn1");

		vif.slv_drv_cb.AWREADY <= 1'b1;

		wait(vif.slv_drv_cb.AWVALID);

		xtn1.AWVALID = vif.slv_drv_cb.AWVALID;
		xtn1.AWID = vif.slv_drv_cb.AWID;
		xtn1.AWADDR = vif.slv_drv_cb.AWADDR;
		xtn1.AWLEN = vif.slv_drv_cb.AWLEN;
		xtn1.AWSIZE = vif.slv_drv_cb.AWSIZE;
		xtn1.AWBURST = vif.slv_drv_cb.AWBURST;
		xtn1.AWLOCK = vif.slv_drv_cb.AWLOCK;
		xtn1.AWCACHE = vif.slv_drv_cb.AWCACHE;
		xtn1.AWPROT = vif.slv_drv_cb.AWPROT;
		xtn1.AWQOS = vif.slv_drv_cb.AWQOS;
		xtn1.AWUSER = vif.slv_drv_cb.AWUSER;

		q1.push_back(xtn1);
		q3.push_back(xtn1);

		vif.slv_drv_cb.AWREADY <= 1'b0;	
	
		repeat($urandom_range(1,5))
			@(vif.slv_drv_cb);

	//	`uvm_info(get_type_name(),$sformatf("Displaying data from slave driver, Drive_Write_Address \n %s",xtn1.sprint()),UVM_MEDIUM)
	endtask

	task slave_driver :: write_data(axi_master_trans xtn1);

		axi_master_trans xtn2;
		xtn2 = axi_master_trans::type_id::create("xtn2");
		xtn2 = xtn1;
		xtn2.write_addr_cal();

		xtn2.WDATA = new[xtn2.AWLEN + 1];

		foreach(xtn2.WDATA[i])
			begin
				vif.slv_drv_cb.WREADY <= 1'b1;
				@(vif.slv_drv_cb);
				wait(vif.slv_drv_cb.WVALID)
				xtn2.WUSER = vif.slv_drv_cb.WUSER;
				xtn2.WVALID = vif.slv_drv_cb.WVALID;
				if(xtn2.WSTRB[i]==4'b1111)
					w_mem[xtn2.w_addr[i]] = vif.slv_drv_cb.WDATA;
				else if(xtn2.WSTRB[i]==4'b0011)
					w_mem[xtn2.w_addr[i]] = vif.slv_drv_cb.WDATA[15:0];
				else if(xtn2.WSTRB[i]==4'b0001)
					w_mem[xtn2.w_addr[i]] = vif.slv_drv_cb.WDATA[7:0];
				else if(xtn2.WSTRB[i]==4'b1110)
					w_mem[xtn2.w_addr[i]] = vif.slv_drv_cb.WDATA[31:8];
				else if(xtn2.WSTRB[i]==4'b1100)
					w_mem[xtn2.w_addr[i]] = vif.slv_drv_cb.WDATA[31:16];
				else if(xtn2.WSTRB[i]==4'b1000)
					w_mem[xtn2.w_addr[i]] = vif.slv_drv_cb.WDATA[31:24];
				else if(xtn2.WSTRB[i]==4'b0100)
					w_mem[xtn2.w_addr[i]] = vif.slv_drv_cb.WDATA[23:16];
				else if(xtn2.WSTRB[i]==4'b0010)
					w_mem[xtn2.w_addr[i]] = vif.slv_drv_cb.WDATA[15:8];

				vif.slv_drv_cb.WREADY <= 1'b0;

				repeat($urandom_range(1,5))
					@(vif.slv_drv_cb);

			end

	//	`uvm_info(get_type_name(),$sformatf("Displaying data from slave driver Drive_Write_Data \n %s",xtn2.sprint()),UVM_MEDIUM)
	endtask

	task slave_driver :: write_response(axi_master_trans xtn1);

		axi_master_trans xtn3;
		xtn3 = axi_master_trans::type_id::create("xtn3");
		xtn3 = xtn1;

		vif.slv_drv_cb.BVALID <= 1'b1;
		vif.slv_drv_cb.BID <= xtn3.AWID;
		vif.slv_drv_cb.BUSER <= xtn3.BUSER;
		vif.slv_drv_cb.BRESP <= 1'b0;

		@(vif.slv_drv_cb);
		wait(vif.slv_drv_cb.BREADY)

		vif.slv_drv_cb.BVALID <= 1'b0;

		repeat($urandom_range(1,5))
			@(vif.slv_drv_cb);
		
	//	`uvm_info(get_type_name(),$sformatf("Displaying data from slave driver Drive_Write_Response \n %s",xtn3.sprint()),UVM_MEDIUM)
	endtask
	
	task slave_driver :: read_address();
		
		axi_master_trans xtn4;
		xtn4 = axi_master_trans::type_id::create("xtn4");

		vif.slv_drv_cb.ARREADY <= 1'b1;

		@(vif.slv_drv_cb);
		wait(vif.slv_drv_cb.ARVALID)

		xtn4.ARVALID = vif.slv_drv_cb.ARVALID;
		xtn4.ARID = vif.slv_drv_cb.ARID;
		xtn4.ARADDR = vif.slv_drv_cb.ARADDR;
		xtn4.ARLEN = vif.slv_drv_cb.ARLEN;
		xtn4.ARSIZE = vif.slv_drv_cb.ARSIZE;
		xtn4.ARBURST = vif.slv_drv_cb.ARBURST;
		xtn4.ARLOCK = vif.slv_drv_cb.ARLOCK;
		xtn4.ARCACHE = vif.slv_drv_cb.ARCACHE;
		xtn4.ARPROT = vif.slv_drv_cb.ARPROT;
		xtn4.ARQOS = vif.slv_drv_cb.ARQOS;
		xtn4.ARUSER = vif.slv_drv_cb.ARUSER;


		q2.push_back(xtn4);

		vif.slv_drv_cb.ARREADY <= 1'b0;
		
		repeat($urandom_range(1,5))
			@(vif.slv_drv_cb);
		
	//	`uvm_info(get_type_name(),$sformatf("Displaying data from slave driver Drive_Read_Address \n %s",xtn4.sprint()),UVM_MEDIUM)
	endtask

	task slave_driver::read_data(axi_master_trans xtn4);

    		axi_master_trans xtn5;
  		xtn5 = axi_master_trans::type_id::create("xtn5");
   		xtn5 = xtn4;

   	 	xtn5.read_addr_cal();
    		xtn5.RDATA = new[xtn5.ARLEN+1];

    		for (int i = 0; i < xtn5.ARLEN+1; i++) begin

        		vif.slv_drv_cb.RVALID <= 1'b1;
        		vif.slv_drv_cb.RID    <= xtn5.ARID;
        		vif.slv_drv_cb.RUSER  <= xtn5.RUSER;
        		vif.slv_drv_cb.RDATA  <= $urandom;
        		vif.slv_drv_cb.RRESP  <= 1'b0;

        		if (i == xtn5.ARLEN)
            			vif.slv_drv_cb.RLAST <= 1'b1;
        		else
            			vif.slv_drv_cb.RLAST <= 1'b0;

        		do begin
            			@(vif.slv_drv_cb);
        		end
        		while (!vif.slv_drv_cb.RREADY);

        		vif.slv_drv_cb.RVALID <= 1'b0;
        		vif.slv_drv_cb.RLAST  <= 1'b0;

        		repeat($urandom_range(1,5))
            			@(vif.slv_drv_cb);
    		end
	//	`uvm_info(get_type_name(),$sformatf("Displaying data from slave driver Drive_Read_Data \n %s",xtn5.sprint()),UVM_MEDIUM)		
	endtask


