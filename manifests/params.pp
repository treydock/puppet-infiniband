# Class: infiniband::params
#
#   The infiniband configuration settings.
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class infiniband::params {

  case $::osfamily {
    'RedHat': {
      if $::architecture == 'x86_64' { 
        $infiniband_support_packages    = [
          'libibcm',
          'libibverbs',
          'libibverbs-utils',
          'librdmacm',
          'librdmacm-utils',
          'rdma',
          'dapl',
          'ibacm',
          'ibsim',
          'ibutils',
          'libcxgb3',
          'libibmad',
          'libibumad',
		  'libipathverbs',
          'libmlx4',
          'libmthca',
          'libnes',
          'rds-tools',
        ]
	  }
	  elsif $::architecture == 'ppc64' {
        $infiniband_support_packages    = [
          'libibcm',
          'libibverbs',
          'libibverbs-utils',
          'librdmacm',
          'librdmacm-utils',
          'rdma',
          'dapl',
          'ibacm',
          'ibsim',
          'ibutils',
          'libcxgb3',
          'libibmad',
          'libibumad',
          'libmlx4',
          'libmthca',
          'libnes',
          'rds-tools',
        ]
	  }
      $optional_infiniband_packages   = [
        'compat-dapl',
        'infiniband-diags',
        'libibcommon',
        'mstflint',
        'opensm',
        'perftest',
        'qperf',
        'srptools',
      ]
      $with_optional_packages         = true
      $rdma_service_name              = 'rdma'
      $rdma_service_has_status        = true
      $rdma_service_has_restart       = true
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only supports osfamily RedHat")
    }
  }

  case $::has_infiniband {
    /true/ : {
      $rdma_service_ensure    = 'running'
      $rdma_service_enable    = true
    }

    default : {
      $rdma_service_ensure    = 'stopped'
      $rdma_service_enable    = false
    }
  }

  $interfaces = $::infiniband_interfaces ? {
    undef   => false,
    default => $::infiniband_interfaces,
  }

}
