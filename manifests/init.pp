# @summary Manage InfiniBand support
#
# @example
#   include infiniband
#
# @param extra_packages
#   The extra packges to install.
# @param rdma_service_ensure
#   RDMA service ensure parameter.
#   Default to 'running' if `has_infiniband` fact is 'true', and 'stopped' if 'has_infiniband' fact is 'false'.
# @param rdma_service_enable
#   RDMA service enable parameter.
#   Default to true if `has_infiniband` fact is 'true', and false if 'has_infiniband' fact is 'false'.
# @param rdma_service_name
#   RDMA service name.
# @param rdma_service_has_status
#   RDMA service has_status parameter.
# @param rdma_service_has_restart
#   RDMA service has_restart parameter.
# @param ibacm_service_ensure
#   ibacm service ensure parameter.
#   Default to 'running' if `has_infiniband` fact is 'true', and 'stopped' if 'has_infiniband' fact is 'false'.
# @param ibacm_service_enable
#   ibacm service enable parameter.
#   Default to true if `has_infiniband` fact is 'true', and false if 'has_infiniband' fact is 'false'.
# @param ibacm_service_name
#   ibacm service name.
# @param ibacm_service_has_status
#   ibacm service has_status parameter.
# @param ibacm_service_has_restart
#   ibacm service has_restart parameter.
# @param rdma_conf_path
#   The RDMA service configuration path.
# @param ipoib_load
#   Sets the `IPOIB_LOAD` setting for the RDMA service.
# @param srp_load
#   Sets the `SRP_LOAD` setting for the RDMA service.
# @param iser_load
#   Sets the `ISER_LOAD` setting for the RDMA service.
# @param rds_load
#   Sets the `RDS_LOAD` setting for the RDMA service.
# @param fixup_mtrr_regs
#   Sets the `FIXUP_MTRR_REGS` setting for the RDMA service.
# @param nfsordma_load
#   Sets the `NFSoRDMA_LOAD` setting for the RDMA service.
# @param nfsordma_port
#   Sets the `NFSoRDMA_PORT` setting for the RDMA service.
# @param manage_mlx4_core_options
#   Boolean that determines if '/etc/modprobe.d/mlx4_core.conf' should be managed.
# @param log_num_mtt
#   Sets the mlx4_core module's 'log_num_mtt' value.
#   When the value is undef the value is determined using the `calc_log_num_mtt` parser function.
# @param log_mtts_per_seg
#   Sets the mlx4_core module's 'log_mtts_per_seq' value.
# @param interfaces
#   This Hash can be used to define `infiniband::interface` resources.
#
class infiniband (
  Array $extra_packages                 = [],
  String $rdma_service_ensure           = $infiniband::params::service_ensure,
  Boolean $rdma_service_enable          = $infiniband::params::service_enable,
  String $rdma_service_name             = $infiniband::params::rdma_service_name,
  Boolean $rdma_service_has_status      = $infiniband::params::rdma_service_has_status,
  Boolean $rdma_service_has_restart     = $infiniband::params::rdma_service_has_restart,
  String $ibacm_service_ensure          = $infiniband::params::service_ensure,
  Boolean $ibacm_service_enable         = $infiniband::params::service_enable,
  String $ibacm_service_name            = $infiniband::params::ibacm_service_name,
  Boolean $ibacm_service_has_status     = $infiniband::params::ibacm_service_has_status,
  Boolean $ibacm_service_has_restart    = $infiniband::params::ibacm_service_has_restart,
  Stdlib::Absolutepath $rdma_conf_path  = $infiniband::params::rdma_conf_path,
  Enum['yes', 'no'] $ipoib_load         = 'yes',
  Enum['yes', 'no'] $srp_load           = 'no',
  Enum['yes', 'no'] $iser_load          = 'no',
  Enum['yes', 'no'] $rds_load           = 'no',
  Enum['yes', 'no'] $fixup_mtrr_regs    = 'no',
  Enum['yes', 'no'] $nfsordma_load      = 'yes',
  Integer[0, 65535] $nfsordma_port      = 2050,
  Boolean $manage_mlx4_core_options     = true,
  Optional[Integer] $log_num_mtt        = undef,
  Integer $log_mtts_per_seg             = 3,
  Hash $interfaces                      = {},
) inherits infiniband::params {
  if $manage_mlx4_core_options {
    $real_log_num_mtt = $log_num_mtt ? {
      Undef   => infiniband::calc_log_num_mtt($facts.dig('memory','system','total_bytes'), $log_mtts_per_seg),
      default => $log_num_mtt,
    }
  }

  include infiniband::install
  include infiniband::config
  include infiniband::service
  include infiniband::providers

  Class['infiniband::install']
  -> Class['infiniband::config']
  -> Class['infiniband::service']
  -> Class['infiniband::providers']
}
