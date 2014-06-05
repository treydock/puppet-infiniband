# puppet-infiniband

[![Build Status](https://travis-ci.org/treydock/puppet-infiniband.png)](https://travis-ci.org/treydock/puppet-infiniband)

Installs the InfiniBand software stack.

## Support

* CentOS 6 x86_64
* Scientific Linux 6 x86_64

## Usage

### infiniband

Standard usage to enable InfiniBand support

    class { 'infiniband': }

Define a IBoIP interface

    class { 'infiniband':
      interfaces  => {
        'ib0' => {'ipaddr' => '192.168.1.1', 'netmask' => '255.255.255.0'}
      }
    }

## Reference

### Classes

#### Public classes

* `infiniband`: Installs and configures a system to use InfiniBand

#### Private lasses

* `infiniband::install`: Installs the InfiniBand packages.
* `infiniband::config`: Manages the rdma.conf file and the mlx4_core module options.
* `infiniband::service`: Manages the rdma and ibacm services.
* `infiniband::providers`: Creates infiniband::interface defined types based on the interfaces parameter.
* `infiniband::params`: Sets default values based on the `osfamily` and `has_infiniband` facts.

### Parameters

#### infiniband

#####`packages`

The packges to install infiniband support.  Default is 'UNSET'.

If 'UNSET' the entire set of Infiniband Support packages will be installed.

#####`with_optional_packages`

If true, the packages in `optional_packages` are installed (defaults to true).

#####`rdma_service_ensure`

RDMA service ensure parameter.  Default to 'running' if `has_infiniband` fact is 'true', and 'stopped' if 'has_infiniband' fact is 'false'.

#####`rdma_service_enable`

RDMA service enable parameter.  Default to true if `has_infiniband` fact is 'true', and false if 'has_infiniband' fact is 'false'.

#####`rdma_service_name`

RDMA service name (defaults to 'rdma').

#####`rdma_service_has_status`

RDMA service has_status parameter (defaults to true).

#####`rdma_service_has_restart`

RDMA service has_restart parameter (defaults to true).

#####`ibacm_service_ensure`

ibacm service ensure parameter.  Default to 'running' if `has_infiniband` fact is 'true', and 'stopped' if 'has_infiniband' fact is 'false'.

#####`ibacm_service_enable`

ibacm service enable parameter.  Default to true if `has_infiniband` fact is 'true', and false if 'has_infiniband' fact is 'false'.

#####`ibacm_service_name`

ibacm service name (defaults to 'ibacm').

#####`ibacm_service_has_status`

ibacm service has_status parameter (defaults to true).

#####`ibacm_service_has_restart`

ibacm service has_restart parameter (defaults to true).

#####`rdma_conf_path`

The RDMA service configuration path (defaults to '/etc/rdma/rdma.conf').

#####`ipoib_load`

Sets the `IPOIB_LOAD` setting for the RDMA service (defaults to 'yes').

#####`srp_load`

Sets the `SRP_LOAD` setting for the RDMA service (defaults to 'no').

#####`iser_load`

Sets the `ISER_LOAD` setting for the RDMA service (defaults to 'no').

#####`rds_load`

Sets the `RDS_LOAD` setting for the RDMA service (defaults to 'no').

#####`fixup_mtrr_regs`

Sets the `FIXUP_MTRR_REGS` setting for the RDMA service (defaults to 'no').

#####`nfsordma_load`

Sets the `NFSoRDMA_LOAD` setting for the RDMA service (defaults to 'yes').

#####`nfsordma_port`

Sets the `NFSoRDMA_PORT` setting for the RDMA service (defaults to '2050').

#####`manage_mlx4_core_options`

Boolean that determines if '/etc/modprobe.d/mlx4_core.conf' should be managed (defaults to true).

#####`log_num_mtt`

Sets the mlx4_core module's 'log_num_mtt' value.  Defaults to 'UNSET'.

When the value is 'UNSET' the value is determined using the `calc_log_num_mtt` parser function.

#####`log_mtts_per_seg`

Sets the mlx4_core module's 'log_mtts_per_seq' value.  Defaults to '3'.

#####`interfaces`

This Hash can be used to define `infiniband::interface` resources (defaults to an empty Hash).

### Defines

#### infiniband::interface

Creates the ifcfg file for an IBoIP interface

    infiniband::interface { 'ib0':
      ipaddr  => '192.168.1.1',
      netmask => '255.255.255.0',
    }

#####`name`

String: the resource title.  Sets the interfaces name, for example 'ib0'.

#####`ipaddr`

String: required, no default.  The IPADDR for the infiniband interface.

#####`netmask`

String: required, no default.  The NETMASK for the infiniband interface.

#####`gateway`

String: defaults to 'UNSET'.  The GATEWAY for the infiniband interface.

#####`ensure`

String: defaults to 'present'.  Sets if the infiniband::interface should be present or absent.

#####`enable`

Boolean: defaults to true.  Sets if the infiniband::interface should be enabled.

#####`connected_mode`

String: defaults to 'yes'.  The CONNECTED_MODE for the infiniband interface.

### Facts

#### has_infiniband

Determine if the system's hardware supports InfiniBand.

#### infiniband_fw_version

Reports the firmware version of the InfiniBand interface card.

**NOTE:** Only supports getting the value from the first interface card found.

#### infiniband_board_id

Returns the board_id (PSID) of the InfiniBand interface card.

**NOTE:** Only supports getting the value from the first interface card found.

#### infiniband_rate

Returns the rate of the InfiniBand interface card.

**NOTE:** Only supports getting the value from the first interface card found.


### Functions

#### calc_log_num_mtt

This function calculates the appropriate value for mlx4_core module's 'log_num_mtt' parameter.

The formula is `max_reg_mem = (2^log_num_mtt) * (2^log_mtts_per_seg) * (page_size_bytes)`.  This function finds the
 log_num_mtt necessary to make 'max_reg_mem' twice the size of system's RAM.  Ref: http://community.mellanox.com/docs/DOC-1120.

*Usage*:

calc_log_num_mtt(`memorysize_mb`, `log_mtts_per_seg`, `page_size_bytes`)

* memorysize_mb - The system's memory size in MBs.  This argument is required.
* log_mtts_per_seg - The value for log_mtts_per_seg.  Defaults to '3' if undefined.
* page_size_bytes - The system's page size in bytes.  Defaults to '4096' if undefined.

*Examples*:

If `$::memorysize_mb` is 129035.57

    calc_log_num_mtt($::memorysize_mb, 3)

Would return 23

    calc_log_num_mtt($::memorysize_mb, 1)

Would return 25

## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake test

If you have Vagrant >= 1.2.0 installed you can run system tests

    bundle exec rake acceptance

## TODO

* Additional facts for IB firmware version, card model, etc.
* Refactor the infiniband facts to be dynamic based on ports found
