# @summary The infiniband default configuration settings.
# @api private
class infiniband::params {
  case $facts['os']['family'] {
    'RedHat': {
      $rdma_service_name          = 'rdma'
      $rdma_service_has_status    = true
      $rdma_service_has_restart   = true
      $ibacm_service_name         = 'ibacm'
      $ibacm_service_has_status   = true
      $ibacm_service_has_restart  = true
      $rdma_conf_path             = '/etc/rdma/rdma.conf'
    }

    default: {
      fail("Unsupported osfamily: ${facts['os']['family']}, module ${module_name} only supports osfamily RedHat")
    }
  }

  # Set default service states based on has_infiniband fact value
  case $facts['has_infiniband'] {
    true : {
      $service_ensure = 'running'
      $service_enable = true
    }
    default : {
      $service_ensure = 'stopped'
      $service_enable = false
    }
  }
}
