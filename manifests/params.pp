# The infiniband default configuration settings.
class infiniband::params {

  case $::osfamily {
    'RedHat': {
      if $::architecture == 'x86_64' { 
          if $::operatingsystemmajrelease == 6 {
            $base_packages    = [
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
         } elsif $::operatingsystemmajrelease == 7 {
             $base_packages    = [
               'libibcm',
               'libibverbs',
               'libibverbs-utils',
               'librdmacm',
               'librdmacm-utils',
               'rdma',
               'dapl',
               'ibacm',
               'ibutils',
               'libcxgb3',
               'libcxgb4',
               'libibmad',
               'libibumad',
               'libipathverbs',
               'libmlx4',
               'libmlx5',
               'libmthca',
               'libnes',
             ]
         }
	  }
	  elsif $::architecture == 'ppc64' {
        $base_packages    = [
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
          'libehca',
        ]
	  }
      $optional_packages = [
        'compat-dapl',
        'infiniband-diags',
        'libibcommon',
        'mstflint',
        'perftest',
        'qperf',
        'srptools',
      ]

      $rdma_service_name          = 'rdma'
      $rdma_service_has_status    = true
      $rdma_service_has_restart   = true
      $ibacm_service_name         = 'ibacm'
      $ibacm_service_has_status   = true
      $ibacm_service_has_restart  = true
      $rdma_conf_path             = '/etc/rdma/rdma.conf'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only supports osfamily RedHat")
    }
  }

  # Set default service states based on has_infiniband fact value
  case $::has_infiniband {
    /true/ : {
      $service_ensure = 'running'
      $service_enable = true
    }

    default : {
      $service_ensure = 'stopped'
      $service_enable = false
    }
  }

}
