# frozen_string_literal: true

require 'spec_helper'

def shellvars
  {
    'IPOIB_LOAD' => { 'value' => 'yes' },
    'SRP_LOAD' => { 'value' => 'no' },
    'ISER_LOAD' => { 'value' => 'no' },
    'RDS_LOAD' => { 'value' => 'no' },
    'FIXUP_MTRR_REGS' => { 'value' => 'no' },
    'NFSoRDMA_LOAD' => { 'value' => 'yes' },
    'NFSoRDMA_PORT' => { 'value' => '2050' },
  }
end

describe 'infiniband' do
  on_supported_os.each do |os, facts|
    context "with #{os}" do
      let :facts do
        facts.merge(has_infiniband: true,
                    memory: { system: { total_bytes: 67_528_032_256 } },)
      end

      let :interfaces_example do
        { 'ib0' => { 'ipaddr' => '192.168.1.1', 'netmask' => '255.255.255.0' } }
      end

      it { is_expected.to create_class('infiniband') }
      it { is_expected.to contain_class('infiniband::params') }

      it { is_expected.to contain_class('infiniband::install').that_comes_before('Class[infiniband::config]') }
      it { is_expected.to contain_class('infiniband::config').that_comes_before('Class[infiniband::service]') }
      it { is_expected.to contain_class('infiniband::service').that_comes_before('Class[infiniband::providers]') }
      it { is_expected.to contain_class('infiniband::providers') }

      describe 'infiniband::install' do
        it { is_expected.to contain_yum__group('infiniband').with_ensure('present') }

        context 'when extra_packages defined' do
          let(:params) { { extra_packages: ['foo'] } }

          it { is_expected.to contain_package('foo') }
        end
      end

      describe 'infiniband::config' do
        it { is_expected.to have_shellvar_resource_count(7) }

        shellvars.each_pair do |name, params|
          it do
            is_expected.to contain_shellvar("infiniband #{name}").with('ensure' => 'present',
                                                                       'target' => '/etc/rdma/rdma.conf',
                                                                       'variable' => name,
                                                                       'value' => params['value'],)
          end
        end

        it do
          is_expected.to contain_file('/etc/modprobe.d/mlx4_core.conf').with('ensure' => 'file',
                                                                             'owner' => 'root',
                                                                             'group' => 'root',
                                                                             'mode' => '0644',)
        end

        it do
          verify_contents(catalogue, '/etc/modprobe.d/mlx4_core.conf', [
                            'options mlx4_core log_num_mtt=22 log_mtts_per_seg=3',
                          ],)
        end

        context 'when log_num_mtt => 26' do
          let(:params) { { manage_mlx4_core_options: true, log_num_mtt: 26 } }

          it do
            verify_contents(catalogue, '/etc/modprobe.d/mlx4_core.conf', [
                              'options mlx4_core log_num_mtt=26 log_mtts_per_seg=3',
                            ],)
          end
        end

        context 'when log_mtts_per_seg => 1' do
          let(:params) { { manage_mlx4_core_options: true, log_mtts_per_seg: 1 } }

          it do
            verify_contents(catalogue, '/etc/modprobe.d/mlx4_core.conf', [
                              'options mlx4_core log_num_mtt=24 log_mtts_per_seg=1',
                            ],)
          end
        end

        context 'when manage_mlx4_core_options => false' do
          let(:params) { { manage_mlx4_core_options: false } }

          it { is_expected.not_to contain_file('/etc/modprobe.d/mlx4_core.conf') }
        end
      end

      describe 'infiniband::service' do
        it do
          is_expected.to contain_service('rdma').with('ensure' => 'running',
                                                      'enable' => 'true',
                                                      'name' => 'rdma',
                                                      'hasstatus' => 'true',
                                                      'hasrestart' => 'true',
                                                      'before' => 'Service[ibacm]',)
        end

        it do
          is_expected.to contain_service('ibacm').with('ensure' => 'running',
                                                       'enable' => 'true',
                                                       'name' => 'ibacm',
                                                       'hasstatus' => 'true',
                                                       'hasrestart' => 'true',)
        end

        context 'when has_infiniband is false' do
          let :facts do
            facts.merge(has_infiniband: false)
          end

          it do
            is_expected.to contain_service('rdma').with('ensure' => 'stopped',
                                                        'enable' => 'false',)
          end

          it do
            is_expected.to contain_service('ibacm').with('ensure' => 'stopped',
                                                         'enable' => 'false',)
          end
        end
      end

      describe 'infiniband::providers' do
        it { is_expected.to have_infiniband__interface_resource_count(0) }

        context 'with parameter interfaces defined' do
          let(:params) { { interfaces: interfaces_example } }

          it { is_expected.to have_infiniband__interface_resource_count(1) }

          it do
            is_expected.to contain_infiniband__interface('ib0').with('ipaddr' => '192.168.1.1',
                                                                     'netmask' => '255.255.255.0',)
          end
        end
      end
    end
  end
end
