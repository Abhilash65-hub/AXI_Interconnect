

class slave_monitor extends uvm_monitor;

	`uvm_component_utils(slave_monitor)

	uvm_analysis_port#(axi_master_trans)monitor_port;

	slave_config slave_cfg;

	virtual axi_slave_interface.SLV_MON_MP vif;

	extern function new(string name = "slave_monitor",uvm_component parent = null);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task handle_write_trans(axi_master_trans xtn);
	extern task handle_read_trans(axi_master_trans xtn);

endclass

	function slave_monitor::new(string name = "slave_monitor",uvm_component parent = null);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction

	function void slave_monitor :: build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(slave_config) :: get(this,"","slave_config",slave_cfg))
			`uvm_error("slave_monitor","getting interface failed")
	endfunction

	function void slave_monitor :: connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif=slave_cfg.vif;
	endfunction

	task slave_monitor::run_phase(uvm_phase phase);
		super.run_phase(phase);
		fork
		forever
			begin
				axi_master_trans write_xtn;
				write_xtn = axi_master_trans::type_id::create("write_xtn");

				@(vif.slv_mon_cb);

				if(!((vif.slv_mon_cb.AWVALID) && (vif.slv_mon_cb.AWREADY)))
					@(vif.slv_mon_cb);

				wait((vif.slv_mon_cb.AWVALID) && (vif.slv_mon_cb.AWREADY));

				write_xtn.AWID = vif.slv_mon_cb.AWID;
				write_xtn.AWADDR = vif.slv_mon_cb.AWADDR;
				write_xtn.AWLEN = vif.slv_mon_cb.AWLEN;
				write_xtn.AWSIZE = vif.slv_mon_cb.AWSIZE;
				write_xtn.AWBURST = vif.slv_mon_cb.AWBURST;
				write_xtn.AWLOCK = vif.slv_mon_cb.AWLOCK;
				write_xtn.AWCACHE = vif.slv_mon_cb.AWCACHE;
				write_xtn.AWPROT = vif.slv_mon_cb.AWPROT;
				write_xtn.AWQOS = vif.slv_mon_cb.AWQOS;
				write_xtn.AWUSER = vif.slv_mon_cb.AWUSER;
				write_xtn.AWVALID = vif.slv_mon_cb.AWVALID;
				write_xtn.AWREADY = vif.slv_mon_cb.AWREADY;

				write_xtn.WDATA = new[write_xtn.AWLEN+1];
				write_xtn.WSTRB = new[write_xtn.AWLEN+1];

				foreach(write_xtn.WDATA[i])
					begin
						forever begin
							@(vif.slv_mon_cb);
							if((vif.slv_mon_cb.WVALID) && (vif.slv_mon_cb.WREADY))
								break;
							end
						write_xtn.WDATA[i] = vif.slv_mon_cb.WDATA;
						write_xtn.WSTRB[i] = vif.slv_mon_cb.WSTRB;
						if(i == (write_xtn.WDATA.size - 1))
							write_xtn.WLAST = vif.slv_mon_cb.WLAST;
						write_xtn.WUSER = vif.slv_mon_cb.WUSER;
						write_xtn.WVALID = vif.slv_mon_cb.WVALID;
						write_xtn.WREADY = vif.slv_mon_cb.WREADY;
					end

				fork
					handle_write_trans(write_xtn);
				join_none			
			end
		forever
			begin
				axi_master_trans read_xtn;
				@(vif.slv_mon_cb);

				if(!((vif.slv_mon_cb.ARVALID) && (vif.slv_mon_cb.ARREADY)))
				@(vif.slv_mon_cb);
				
				wait((vif.slv_mon_cb.ARVALID) && (vif.slv_mon_cb.ARREADY));
				
				read_xtn = axi_master_trans::type_id::create("read_xtn");
				read_xtn.ARID = vif.slv_mon_cb.ARID;
				read_xtn.ARADDR = vif.slv_mon_cb.ARADDR;
				read_xtn.ARLEN = vif.slv_mon_cb.ARLEN;
				read_xtn.ARSIZE = vif.slv_mon_cb.ARSIZE;
				read_xtn.ARBURST = vif.slv_mon_cb.ARBURST;
				read_xtn.ARLOCK = vif.slv_mon_cb.ARLOCK;
				read_xtn.ARCACHE = vif.slv_mon_cb.ARCACHE;
				read_xtn.ARPROT = vif.slv_mon_cb.ARPROT;
				read_xtn.ARQOS = vif.slv_mon_cb.ARQOS;
				read_xtn.ARUSER = vif.slv_mon_cb.ARUSER;
				read_xtn.ARVALID = vif.slv_mon_cb.ARVALID;
				read_xtn.ARREADY = vif.slv_mon_cb.ARREADY;

				fork
					handle_read_trans(read_xtn);
				join_none
			end
		join
	endtask

	task slave_monitor::handle_write_trans(axi_master_trans xtn);

		forever begin
			@(vif.slv_mon_cb);
			if((vif.slv_mon_cb.BVALID) && (vif.slv_mon_cb.BREADY) && (vif.slv_mon_cb.BID == xtn.AWID))
				break;
			end
		xtn.BID = vif.slv_mon_cb.BID;
		xtn.BRESP = vif.slv_mon_cb.BRESP;
		xtn.BUSER = vif.slv_mon_cb.BUSER;
		xtn.BVALID = vif.slv_mon_cb.BVALID;
		xtn.BREADY = vif.slv_mon_cb.BREADY;
#1;	$display({
  "\n========== SLAVE MONITOR ==========\n",
  "AWID    = 0x%02h\n",
  "AWADDR  = 0x%08h\n",
  "AWBURST = %0b\n",
  "AWLEN   = %0d\n",
  "AWSIZE  = %0d\n",
    "==========================================="
},
xtn.AWID,
xtn.AWADDR,
xtn.AWBURST,
xtn.AWLEN,
xtn.AWSIZE,
);

				monitor_port.write(xtn);
	endtask

	task slave_monitor::handle_read_trans(axi_master_trans xtn);

		xtn.RDATA = new[xtn.ARLEN+1];
		xtn.RRESP = new[xtn.ARLEN+1];
		foreach(xtn.RDATA[i])
			begin
				forever begin
					@(vif.slv_mon_cb);
					if((vif.slv_mon_cb.RVALID) && (vif.slv_mon_cb.RREADY) && (vif.slv_mon_cb.RID == xtn.ARID))
						break;
					end
				xtn.RID = vif.slv_mon_cb.RID;		
				xtn.RDATA[i] = vif.slv_mon_cb.RDATA;
				xtn.RRESP[i] = vif.slv_mon_cb.RRESP;
				if(i == (xtn.RDATA.size - 1))
					xtn.RLAST = vif.slv_mon_cb.RLAST;
				xtn.RUSER = vif.slv_mon_cb.RUSER;
				xtn.RVALID = vif.slv_mon_cb.RVALID;
				xtn.RREADY = vif.slv_mon_cb.RREADY;
			end
		monitor_port.write(xtn);

	endtask




