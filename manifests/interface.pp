# == Define: infiniband::interface
#
# See README.md for more details.
define infiniband::interface(
  $ipaddr,
  $netmask,
  $gateway        = 'UNSET',
  $ensure         = 'present',
  $enable         = true,
  $connected_mode = 'yes'
) {

  include network

  validate_re($ensure, ['^present$','^absent$'])

  $enable_real = is_string($enable) ? {
    true  => str2bool($enable),
    false => $enable,
  }
  validate_bool($enable_real)

  validate_re($connected_mode, ['^yes$','^no$'])

  if $enable_real {
    $onboot = 'yes'
  } else {
    $onboot = 'no'
  }

  file { "/etc/sysconfig/network-scripts/ifcfg-${name}":
    ensure  => $ensure,
    content => template('infiniband/ifcfg.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['network'],
  }

}
