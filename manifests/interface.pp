# @summary Manage IPoIB interface
#
# @example Creates the ifcfg file for an IBoIP interface
#   infiniband::interface { 'ib0':
#     ipaddr  => '192.168.1.1',
#     netmask => '255.255.255.0',
#   }
#
#
# @param name
#   The resource title.  Sets the interfaces name, for example 'ib0'.
# @param ipaddr
#   The IPADDR for the infiniband interface.
# @param netmask
#   The NETMASK for the infiniband interface.
# @param gateway
#   The GATEWAY for the infiniband interface.
# @param ensure
#   Sets if the infiniband::interface should be present or absent.
# @param enable
#   Sets if the infiniband::interface should be enabled at boot.
# @param connected_mode
#   The CONNECTED_MODE value for the infiniband interface.
# @param mtu
#   The MTU for the infiniband interface.
# @param bonding
#   If this interface is a bonding interface (true/false); defaults to false
# @param bonding_slaves
#   Array of interfaces that should be enslaved in the bonding interface
# @param bonding_opts
#   The bonding options to use for this bonding interface
#
define infiniband::interface (
  Stdlib::Compat::Ip_address $ipaddr,
  Stdlib::Compat::Ip_address $netmask,
  Optional[Stdlib::Compat::Ip_address] $gateway = undef,
  Enum['present', 'absent'] $ensure             = 'present',
  Boolean $enable                               = true,
  Enum['yes', 'no'] $connected_mode             = 'yes',
  Enum['yes', 'no'] $nm_controlled              = 'no',
  Optional[Integer] $mtu                        = undef,
  Boolean $bonding                              = false,
  Array[String] $bonding_slaves                 = [],
  String $bonding_opts                          = 'mode=active-backup miimon=100',
) {

  $onboot = $enable ? {
    String  => $enable,
    Boolean => $enable ? {
      true  => 'yes',
      false => 'no',
    },
  }

  $options_extra_redhat = {
    'CONNECTED_MODE' => $connected_mode,
  }

  if $bonding {
    if empty($bonding_slaves) {
      fail("No slave interfaces given for bonding interface ${name}")
    }

    # Setup interfaces for the slaves
    $bonding_slaves.each |String $ifname| {
      network::interface { $ifname:
        ensure               => $ensure,
        enable               => $enable,
        onboot               => $onboot,
        type                 => 'InfiniBand',
        master               => $name,
        slave                => 'yes',
        nm_controlled        => $nm_controlled,
        mtu                  => $mtu,
        options_extra_redhat => $options_extra_redhat,
      }
    }

    # Setup the bonding interface
    network::interface { $name:
      ensure         => $ensure,
      enable         => $enable,
      onboot         => $onboot,
      type           => 'Bond',
      ipaddress      => $ipaddr,
      netmask        => $netmask,
      gateway        => $gateway,
      bonding_master => 'yes',
      bonding_opts   => $bonding_opts,
      nm_controlled  => $nm_controlled,
      mtu            => $mtu,
    }

  } else {
    network::interface { $name:
      ensure               => $ensure,
      enable               => $enable,
      onboot               => $onboot,
      type                 => 'InfiniBand',
      ipaddress            => $ipaddr,
      netmask              => $netmask,
      gateway              => $gateway,
      nm_controlled        => $nm_controlled,
      mtu                  => $mtu,
      options_extra_redhat => $options_extra_redhat,
    }
  }

}
