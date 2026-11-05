


class master_monitor extends uvm_monitor;

        `uvm_component_utils(master_monitor)

        master_config master_cfg;

        uvm_analysis_port#(axi_master_trans)monitor_port;

        virtual axi_master_interface.MAST_MON_MP vif;

        extern function new(string name = "master_monitor",uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task handle_write_trans(axi_master_trans xtn);
        extern task handle_read_trans(axi_master_trans xtn);

endclass

        function master_monitor::new(string name = "master_monitor",uvm_component parent = null);
                super.new(name,parent);
                monitor_port = new("monitor_port",this);
        endfunction

        function void master_monitor :: build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db #(master_config) :: get(this,"","master_config",master_cfg))
                        `uvm_error("master_monitor","getting interface failed")
        endfunction

        function void master_monitor :: connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                vif=master_cfg.vif;
        endfunction

/*      task master_monitor::run_phase(uvm_phase phase);
                super.run_phase(phase);
                fork
                forever
                        begin
                                axi_master_trans write_xtn;
                                write_xtn = axi_master_trans::type_id::create("write_xtn");

                                @(vif.mast_mon_cb);

                                if(!((vif.mast_mon_cb.AWVALID) && (vif.mast_mon_cb.AWREADY)))
                                        @(vif.mast_mon_cb);

                                wait((vif.mast_mon_cb.AWVALID) && (vif.mast_mon_cb.AWREADY));

                                write_xtn.AWID = vif.mast_mon_cb.AWID;
                                write_xtn.AWADDR = vif.mast_mon_cb.AWADDR;
                                write_xtn.AWLEN = vif.mast_mon_cb.AWLEN;
                                write_xtn.AWSIZE = vif.mast_mon_cb.AWSIZE;
                                write_xtn.AWBURST = vif.mast_mon_cb.AWBURST;
                                write_xtn.AWLOCK = vif.mast_mon_cb.AWLOCK;
                                write_xtn.AWCACHE = vif.mast_mon_cb.AWCACHE;
                                write_xtn.AWPROT = vif.mast_mon_cb.AWPROT;
                                write_xtn.AWQOS = vif.mast_mon_cb.AWQOS;
                                write_xtn.AWUSER = vif.mast_mon_cb.AWUSER;
                                write_xtn.AWVALID = vif.mast_mon_cb.AWVALID;
                                write_xtn.AWREADY = vif.mast_mon_cb.AWREADY;

                                write_xtn.WDATA = new[write_xtn.AWLEN+1];
                                write_xtn.WSTRB = new[write_xtn.AWLEN+1];

                                foreach(write_xtn.WDATA[i])
                                        begin
                                                forever begin
                                                        @(vif.mast_mon_cb);
                                                        if((vif.mast_mon_cb.WVALID) && (vif.mast_mon_cb.WREADY))
                                                                break;
                                                        end
                                                write_xtn.WDATA[i] = vif.mast_mon_cb.WDATA;
                                                write_xtn.WSTRB[i] = vif.mast_mon_cb.WSTRB;
                                                if(i == (write_xtn.WDATA.size - 1))
                                                        write_xtn.WLAST = vif.mast_mon_cb.WLAST;
                                                write_xtn.WUSER = vif.mast_mon_cb.WUSER;
                                                write_xtn.WVALID = vif.mast_mon_cb.WVALID;
                                                write_xtn.WREADY = vif.mast_mon_cb.WREADY;
                                        end
                                fork
                                        handle_write_trans(write_xtn);
                                join_none
                        end
                forever
                        begin
                                axi_master_trans read_xtn;
                                @(vif.mast_mon_cb);
                                if(!((vif.mast_mon_cb.ARVALID) && (vif.mast_mon_cb.ARREADY)))
                                @(vif.mast_mon_cb);
                                wait((vif.mast_mon_cb.ARVALID) && (vif.mast_mon_cb.ARREADY));

                                read_xtn = axi_master_trans::type_id::create("read_xtn");
                                read_xtn.ARID = vif.mast_mon_cb.ARID;
                                read_xtn.ARADDR = vif.mast_mon_cb.ARADDR;
                                read_xtn.ARLEN = vif.mast_mon_cb.ARLEN;
                                read_xtn.ARSIZE = vif.mast_mon_cb.ARSIZE;
                                read_xtn.ARBURST = vif.mast_mon_cb.ARBURST;
                                read_xtn.ARLOCK = vif.mast_mon_cb.ARLOCK;
                                read_xtn.ARCACHE = vif.mast_mon_cb.ARCACHE;
                                read_xtn.ARPROT = vif.mast_mon_cb.ARPROT;
                                read_xtn.ARQOS = vif.mast_mon_cb.ARQOS;
                                read_xtn.ARUSER = vif.mast_mon_cb.ARUSER;
                                read_xtn.ARVALID = vif.mast_mon_cb.ARVALID;
                                read_xtn.ARREADY = vif.mast_mon_cb.ARREADY;

                                fork
                                        handle_read_trans(read_xtn);
                                join_none
                        end
                join
        endtask
*/

task master_monitor::run_phase(uvm_phase phase);
  super.run_phase(phase);

  fork

    //================================================
    // WRITE ADDRESS AND DATA MONITOR
    //================================================
    forever begin
      axi_master_trans write_xtn;

      @(vif.mast_mon_cb);

      // Capture only on a sampled AW handshake
      if (vif.mast_mon_cb.AWVALID &&
          vif.mast_mon_cb.AWREADY) begin

        write_xtn =
          axi_master_trans::type_id::create("write_xtn");

        write_xtn.AWID    = vif.mast_mon_cb.AWID;
        write_xtn.AWADDR  = vif.mast_mon_cb.AWADDR;
        write_xtn.AWLEN   = vif.mast_mon_cb.AWLEN;
        write_xtn.AWSIZE  = vif.mast_mon_cb.AWSIZE;
        write_xtn.AWBURST = vif.mast_mon_cb.AWBURST;
        write_xtn.AWLOCK  = vif.mast_mon_cb.AWLOCK;
        write_xtn.AWCACHE = vif.mast_mon_cb.AWCACHE;
        write_xtn.AWPROT  = vif.mast_mon_cb.AWPROT;
        write_xtn.AWQOS   = vif.mast_mon_cb.AWQOS;
        write_xtn.AWUSER  = vif.mast_mon_cb.AWUSER;
        write_xtn.AWVALID = vif.mast_mon_cb.AWVALID;
        write_xtn.AWREADY = vif.mast_mon_cb.AWREADY;

        `uvm_info("MASTER_MON_WRITE",
          $sformatf(
            "AW HANDSHAKE: ID=%0h ADDR=%0h LEN=%0d",
            write_xtn.AWID,
            write_xtn.AWADDR,
            write_xtn.AWLEN
          ),
          UVM_MEDIUM)

        write_xtn.WDATA = new[write_xtn.AWLEN + 1];
        write_xtn.WSTRB = new[write_xtn.AWLEN + 1];

        // Capture all write-data beats
        foreach (write_xtn.WDATA[i]) begin
          forever begin
            @(vif.mast_mon_cb);

            if (vif.mast_mon_cb.WVALID &&
                vif.mast_mon_cb.WREADY)
              break;
          end

          write_xtn.WDATA[i] = vif.mast_mon_cb.WDATA;
          write_xtn.WSTRB[i] = vif.mast_mon_cb.WSTRB;

          write_xtn.WUSER  = vif.mast_mon_cb.WUSER;
          write_xtn.WVALID = vif.mast_mon_cb.WVALID;
          write_xtn.WREADY = vif.mast_mon_cb.WREADY;

          if (i == write_xtn.WDATA.size() - 1)
            write_xtn.WLAST = vif.mast_mon_cb.WLAST;
        end

        // Wait for the corresponding write response
        fork
          handle_write_trans(write_xtn);
        join_none
      end
    end

    //================================================
    // READ ADDRESS MONITOR
    //================================================
    forever begin
      axi_master_trans read_xtn;

      @(vif.mast_mon_cb);

      // Capture only on a sampled AR handshake
      if (vif.mast_mon_cb.ARVALID &&
          vif.mast_mon_cb.ARREADY) begin

        read_xtn =
          axi_master_trans::type_id::create("read_xtn");

        read_xtn.ARID    = vif.mast_mon_cb.ARID;
        read_xtn.ARADDR  = vif.mast_mon_cb.ARADDR;
        read_xtn.ARLEN   = vif.mast_mon_cb.ARLEN;
        read_xtn.ARSIZE  = vif.mast_mon_cb.ARSIZE;
        read_xtn.ARBURST = vif.mast_mon_cb.ARBURST;
        read_xtn.ARLOCK  = vif.mast_mon_cb.ARLOCK;
        read_xtn.ARCACHE = vif.mast_mon_cb.ARCACHE;
        read_xtn.ARPROT  = vif.mast_mon_cb.ARPROT;
        read_xtn.ARQOS   = vif.mast_mon_cb.ARQOS;
        read_xtn.ARUSER  = vif.mast_mon_cb.ARUSER;
        read_xtn.ARVALID = vif.mast_mon_cb.ARVALID;
        read_xtn.ARREADY = vif.mast_mon_cb.ARREADY;

        `uvm_info("MASTER_MON_READ",
          $sformatf(
            "AR HANDSHAKE: ID=%0h ADDR=%0h LEN=%0d",
            read_xtn.ARID,
            read_xtn.ARADDR,
            read_xtn.ARLEN
          ),
          UVM_MEDIUM)

        // Collect response/data for this read
        fork
          handle_read_trans(read_xtn);
        join_none
      end
    end

  join
endtask


        task master_monitor::handle_write_trans(axi_master_trans xtn);

                forever begin
                        @(vif.mast_mon_cb);
                        if((vif.mast_mon_cb.BVALID) && (vif.mast_mon_cb.BREADY) && (vif.mast_mon_cb.BID == xtn.AWID))
                                break;
                        end
                xtn.BID = vif.mast_mon_cb.BID;
                xtn.BRESP = vif.mast_mon_cb.BRESP;
                xtn.BUSER = vif.mast_mon_cb.BUSER;
                xtn.BVALID = vif.mast_mon_cb.BVALID;
                xtn.BREADY = vif.mast_mon_cb.BREADY;
                $display({
  "\n========== MASTER MONITOR ==========\n",
  "AWID    = 0x%02h\n",
  "AWADDR  = 0x%08h\n",
  "AWBURST = %0b\n",
  "AWLEN   = %0d\n",
  "AWSIZE  = %0d\n",
    "==========================================="
},
vif.mast_mon_cb.AWID,
vif.mast_mon_cb.AWADDR,
vif.mast_mon_cb.AWBURST,
vif.mast_mon_cb.AWLEN,
vif.mast_mon_cb.AWSIZE,
);
                monitor_port.write(xtn);
        endtask

        task master_monitor::handle_read_trans(axi_master_trans xtn);

                xtn.RDATA = new[xtn.ARLEN+1];
                xtn.RRESP = new[xtn.ARLEN+1];
                foreach(xtn.RDATA[i])
                        begin
                                forever begin
                                        @(vif.mast_mon_cb);
                                        if((vif.mast_mon_cb.RVALID) && (vif.mast_mon_cb.RREADY) && (vif.mast_mon_cb.RID == xtn.ARID))
                                                break;
                                        end
                                xtn.RID = vif.mast_mon_cb.RID;
                                xtn.RDATA[i] = vif.mast_mon_cb.RDATA;
                                xtn.RRESP[i] = vif.mast_mon_cb.RRESP;
                                if(i == (xtn.RDATA.size - 1))
                                        xtn.RLAST = vif.mast_mon_cb.RLAST;
                                xtn.RUSER = vif.mast_mon_cb.RUSER;
                                xtn.RVALID = vif.mast_mon_cb.RVALID;
                                xtn.RREADY = vif.mast_mon_cb.RREADY;
                        end
                monitor_port.write(xtn);

        endtask

