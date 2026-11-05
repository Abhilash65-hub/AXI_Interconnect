# AXI_Interconnect


# AXI Protocol Verification Using SystemVerilog and UVM

## Project Overview

This project implements a UVM-based verification environment for an AMBA AXI protocol design. It contains AXI master and slave agents, a testbench environment, a scoreboard, and test sequences.

The verification environment is organized into reusable components to support stimulus generation, transaction driving, monitoring, and checking.

## Project Directory Structure

```text
AXI-Verification/
│
├── AXI_Master/
│   ├── axi_agent.sv
│   ├── axi_agent_top.sv
│   ├── axi_config.sv
│   ├── axi_driver.sv
│   ├── axi_monitor.sv
│   ├── axi_seqr.sv
│   ├── axi_sequence.sv
│   └── axi_xtn.sv
│
├── AXI_Slave/
│   ├── axi_s_agent.sv
│   ├── axi_slv_agent_top.sv
│   ├── axi_slv_config.sv
│   ├── axi_slv_driver.sv
│   ├── axi_slv_monitor.sv
│   ├── axi_slv_seqr.sv
│   ├── axi_slv_sequence.sv
│   └── axi_slv_xtn.sv
│
├── tb/
│   ├── env.sv
│   ├── env_config.sv
│   └── scoreboard.sv
│
├── test/
│   └── test.sv
│
└── README.md
```

## Components

### AXI Master Agent

The `AXI_Master` directory contains the master-side UVM components.

- **axi_xtn.sv** — Defines AXI master transaction fields.
- **axi_sequence.sv** — Generates AXI stimulus.
- **axi_seqr.sv** — Manages sequence execution.
- **axi_driver.sv** — Drives AXI transactions onto the interface.
- **axi_monitor.sv** — Observes master-side AXI activity.
- **axi_config.sv** — Stores master agent configuration.
- **axi_agent.sv** — Combines the master agent components.
- **axi_agent_top.sv** — Instantiates and configures master agents.

### AXI Slave Agent

The `AXI_Slave` directory contains the slave-side UVM components.

- **axi_slv_xtn.sv** — Defines AXI slave transaction fields.
- **axi_slv_sequence.sv** — Generates slave-side stimulus.
- **axi_slv_seqr.sv** — Manages slave sequence execution.
- **axi_slv_driver.sv** — Drives slave responses.
- **axi_slv_monitor.sv** — Observes slave-side AXI activity.
- **axi_slv_config.sv** — Stores slave agent configuration.
- **axi_s_agent.sv** — Combines the slave agent components.
- **axi_slv_agent_top.sv** — Instantiates and configures slave agents.

### Testbench Environment

The `tb` directory contains the top-level verification environment.

- **env.sv** — Instantiates and connects the AXI agents and scoreboard.
- **env_config.sv** — Provides configuration for the verification environment.
- **scoreboard.sv** — Checks and compares observed transactions.

### Test

The `test` directory contains:

- **test.sv** — Defines the UVM test and starts the required sequences.

## Verification Features

The verification environment is intended to check AXI transactions, including:

- Write and read transactions
- Address and control information
- Burst-related fields
- Write data and byte strobes
- Response information
- Master-side and slave-side transaction matching
- Scoreboard-based transaction checking

The exact supported scenarios depend on the sequences and RTL connected to the testbench.

## Simulation

This project is developed using SystemVerilog and UVM and can be simulated with a compatible simulator such as Synopsys VCS.

A typical VCS flow is:

1. Compile the RTL and UVM testbench files.
2. Run the required UVM test.
3. Review the simulation log.
4. Check the scoreboard results and coverage report.

The exact compile and run commands depend on the RTL files, interface definitions, package files, and simulator setup used in the project.

## Tools and Technologies

- SystemVerilog
- Universal Verification Methodology (UVM)
- AMBA AXI Protocol
- Synopsys VCS

## Project Goal

The goal of this project is to develop a reusable UVM-based AXI verification environment and verify AXI transaction behavior through stimulus generation, monitoring, and scoreboard checking.
