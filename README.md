# puppet-infiniband

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/infiniband.svg)](https://forge.puppetlabs.com/treydock/infiniband)
[![Build Status](https://travis-ci.org/treydock/puppet-infiniband.svg?branch=master)](https://travis-ci.org/treydock/puppet-infiniband)

Installs the InfiniBand software stack.

## Support

* RedHat/CentOS 7
* RedHat/Rocky/Alma 8

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

[http://treydock.github.io/puppet-infiniband/](http://treydock.github.io/puppet-infiniband/)

### Facts

#### has_infiniband

Determine if the system's hardware supports InfiniBand.

#### infiniband\_fw\_version

Reports the firmware version of the InfiniBand interface card.

**NOTE:** Only supports getting the value from the first interface card found.

#### infiniband\_board\_id

Returns the board_id (PSID) of the InfiniBand interface card.

**NOTE:** Only supports getting the value from the first interface card found.

#### infiniband_rate

Returns the rate of the InfiniBand interface card.

**NOTE:** Only supports getting the value from the first interface card found.

#### infiniband_hcas

Returns Array of HCAs:

```
[
  "mlx5_0",
  "mlx5_1",
  "mlx5_2",
  "mlx5_3"
]
```

#### infiniband_hca_board_id

Returns Hash of PSID / Board IDs for each HCA:

```
{
  mlx5_0 => "MT_0000000023",
  mlx5_1 => "MT_0000000023",
  mlx5_2 => "MT_0000000023",
  mlx5_3 => "MT_0000000023"
}
```

#### infiniband_hca_port_guids

Return Hash of HCA port GUIDs:

```
{
  mlx5_0 => {
    1 => "0x506b4b0300aaffcc"
  },
  mlx5_1 => {
    1 => "0x506b4b0300aaffcd"
  },
  mlx5_2 => {
    1 => "0x506b4b0300aaffc6"
  },
  mlx5_3 => {
    1 => "0x506b4b0300aaffc7"
  }
}
```

#### infiniband_netdevs

Return Hash of IPoIB netdev information:

```
{
  ib0 => {
    hca => "mlx5_0",
    port => "1",
    state => "ACTIVE",
    rate => "100",
    link_layer => "InfiniBand"
  }
}
```
