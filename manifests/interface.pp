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
# @param nm_controlled
#   Value for nm_controlled on interface
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
  Enum['present', 'absent'] $ensure = 'present',
  Optional[Stdlib::IP::Address] $ipaddr = undef,
  Optional[Stdlib::IP::Address] $netmask = undef,
  Optional[Stdlib::IP::Address] $gateway = undef,
  Boolean $enable = true,
  Enum['yes', 'no'] $connected_mode = 'yes',
  Optional[Enum['yes','no']] $nm_controlled = undef,
  Optional[Integer] $mtu = undef,
  Boolean $bonding = false,
  Array[String] $bonding_slaves = [],
  String $bonding_opts = 'mode=active-backup miimon=100',
) {
  if $ensure == 'present' {
    if ! $ipaddr {
      fail('ipaddr is required with ensure=present')
    }
    if ! $netmask {
      fail('netmask is required with ensure=present')
    }
  }
  if $bonding {
    if empty($bonding_slaves) {
      fail("No slave interfaces given for bonding interface ${name}")
    }

    # Setup interfaces for the slaves
    $bonding_slaves.each |String $ifname| {
      network_config { $ifname:
        ensure  => $ensure,
        onboot  => $enable,
        mtu     => $mtu,
        method  => 'static',
        hotplug => false,
        options => {
          'TYPE'           => 'Infiniband',
          'MASTER'         => $name,
          'SLAVE'          => 'yes',
          'CONNECTED_MODE' => $connected_mode,
          'NM_CONTROLLED'  => $nm_controlled,
        }.filter |$k, $v| { $v =~ NotUndef },
      }
    }

    # Setup the bonding interface
    network_config { $name:
      ensure    => $ensure,
      onboot    => $enable,
      ipaddress => $ipaddr,
      netmask   => $netmask,
      mtu       => $mtu,
      method    => 'static',
      hotplug   => false,
      options   => {
        'TYPE'           => 'Bond',
        'BONDING_MASTER' => 'yes',
        'BONDING_OPTS'   => $bonding_opts,
        'GATEWAY'        => $gateway,
        'CONNECTED_MODE' => $connected_mode,
        'NM_CONTROLLED'  => $nm_controlled,
      }.filter |$k, $v| { $v =~ NotUndef },
    }
  } else {
    network_config { $name:
      ensure    => $ensure,
      onboot    => $enable,
      ipaddress => $ipaddr,
      netmask   => $netmask,
      mtu       => $mtu,
      method    => 'static',
      hotplug   => false,
      options   => {
        'TYPE'           => 'Infiniband',
        'GATEWAY'        => $gateway,
        'CONNECTED_MODE' => $connected_mode,
        'NM_CONTROLLED'  => $nm_controlled,
      }.filter |$k, $v| { $v =~ NotUndef },
    }
  }
}
