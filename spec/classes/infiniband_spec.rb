require 'spec_helper'

def shellvars
  {
    'IPOIB_LOAD'      => { 'value' => 'yes' },
    'SRP_LOAD'        => { 'value' => 'no' },
    'ISER_LOAD'       => { 'value' => 'no' },
    'RDS_LOAD'        => { 'value' => 'no' },
    'FIXUP_MTRR_REGS' => { 'value' => 'no' },
    'NFSoRDMA_LOAD'   => { 'value' => 'yes' },
    'NFSoRDMA_PORT'   => { 'value' => '2050' },
  }
end

def base_packages
  [
    'dapl',
    'ibacm',
    'ibsim',
    'ibutils',
    'libcxgb3',
    'libibcm',
    'libibmad',
    'libibumad',
    'libibverbs',
    'libibverbs-utils',
    'libipathverbs',
    'libmlx4',
    'libmthca',
    'libnes',
    'librdmacm',
    'librdmacm-utils',
    'rdma',
    'rds-tools',
  ]
end

def optional_packages
  [
    'compat-dapl',
    'infiniband-diags',
    'libibcommon',
    'mstflint',
    'perftest',
    'qperf',
    'srptools',
  ]
end

describe 'infiniband' do
  include_context :defaults

  let(:facts) { default_facts }

  let :interfaces_example do
    { 'ib0' => {'ipaddr' => '192.168.1.1', 'netmask'  => '255.255.255.0'} }
  end

  it { should create_class('infiniband') }
  it { should contain_class('infiniband::params') }

  it { should contain_anchor('infiniband::start').that_comes_before('Class[infiniband::install]') }
  it { should contain_class('infiniband::install').that_comes_before('Class[infiniband::config]') }
  it { should contain_class('infiniband::config').that_comes_before('Class[infiniband::service]') }
  it { should contain_class('infiniband::service').that_comes_before('Class[infiniband::providers]') }
  it { should contain_class('infiniband::providers').that_comes_before('Anchor[infiniband::end]') }
  it { should contain_anchor('infiniband::end') }

  context "infiniband::install" do
    it { should have_package_resource_count(base_packages.size + optional_packages.size) }

    base_packages.each do |package|
      it { should contain_package(package).with_ensure('present') }
    end

    optional_packages.each do |optional_package|
      it { should contain_package(optional_package).with_ensure('present') }
    end

    context 'with_optional_packages => false' do
      let(:params) {{ :with_optional_packages => false }}

      it { should have_package_resource_count(base_packages.size) }

      optional_packages.each do |optional_package|
        it { should_not contain_package(optional_package) }
      end

      context "when with_optional_packages => true and packages => ['foo']" do
        let(:params) {{ :with_optional_packages => true, :packages => ['foo'] }}

        it { should have_package_resource_count(1) }
        it { should contain_package('foo').with_ensure('present') }
      end
    end
  end

  context "infiniband::config" do
    it { should have_shellvar_resource_count(7) }

    shellvars.each_pair do |name,params|
      it do
        should contain_shellvar("infiniband #{name}").with({
          'ensure'  => 'present',
          'target'    => '/etc/rdma/rdma.conf',
          'variable'  => name,
          'value'     => params['value'],
        })
      end
    end


    it do
      should contain_file('/etc/modprobe.d/mlx4_core.conf').with({
        'ensure'  => 'file',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      })
    end

    it do
      verify_contents(catalogue, '/etc/modprobe.d/mlx4_core.conf', [
        'options mlx4_core log_num_mtt=22 log_mtts_per_seg=3',
      ])
    end

    context 'when log_num_mtt => 26' do
      let(:params) {{ :manage_mlx4_core_options => true, :log_num_mtt => '26' }}

      it do
        verify_contents(catalogue, '/etc/modprobe.d/mlx4_core.conf', [
          'options mlx4_core log_num_mtt=26 log_mtts_per_seg=3',
        ])
      end
    end

    context 'when log_mtts_per_seg => 1' do
      let(:params) {{ :manage_mlx4_core_options => true, :log_mtts_per_seg => '1' }}

      it do
        verify_contents(catalogue, '/etc/modprobe.d/mlx4_core.conf', [
          'options mlx4_core log_num_mtt=24 log_mtts_per_seg=1',
        ])
      end
    end

    context "when manage_mlx4_core_options => false" do
      let(:params) {{ :manage_mlx4_core_options => false }}

      it { should_not contain_file('/etc/modprobe.d/mlx4_core.conf') }
    end
  end

  context "infiniband::service" do
    it do
      should contain_service('rdma').with({
        'ensure'      => 'running',
        'enable'      => 'true',
        'name'        => 'rdma',
        'hasstatus'   => 'true',
        'hasrestart'  => 'true',
        'before'      => 'Service[ibacm]',
      })
    end

    it do
      should contain_service('ibacm').with({
        'ensure'      => 'running',
        'enable'      => 'true',
        'name'        => 'ibacm',
        'hasstatus'   => 'true',
        'hasrestart'  => 'true',
      })
    end

    context "has_infiniband is false" do
      let(:facts) { default_facts.merge({:has_infiniband => false }) }

      it do
        should contain_service('rdma').with({
          'ensure'      => 'stopped',
          'enable'      => 'false',
        })
      end

      it do
        should contain_service('ibacm').with({
          'ensure'      => 'stopped',
          'enable'      => 'false',
        })
      end
    end
  end

  context "infiniband::providers" do
    it { should have_infiniband__interface_resource_count(0) }

    context "with parameter interfaces defined" do
      let(:params) {{ :interfaces => interfaces_example }}

      it { should have_infiniband__interface_resource_count(1) }

      it do
        should contain_infiniband__interface('ib0').with({
          'ipaddr'  => '192.168.1.1',
          'netmask' => '255.255.255.0',
        })
      end
    end
  end

  # Test validate_bool parameters
  [
    'with_optional_packages',
    'manage_mlx4_core_options',
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('infiniband') }.to raise_error(Puppet::Error, /is not a boolean/) }
    end
  end

  # Test validate_re parameters
  [
    'ipoib_load',
    'srp_load',
    'iser_load',
    'rds_load',
    'fixup_mtrr_regs',
    'nfsordma_load',
  ].each do |p|
    context "when #{p} => 'foo'" do
      let(:params) {{ p.to_sym => 'foo' }}
      it { expect { should create_class('infiniband') }.to raise_error(Puppet::Error, /does not match \["\^yes\$", "\^no\$"\]/) }
    end
  end

  # Test validate_hash parameters
  [
    'interfaces',
  ].each do |p|
    context "when #{p} => 'foo'" do
      let(:params) {{ p.to_sym => 'foo' }}
      it { expect { should create_class('infiniband') }.to raise_error(Puppet::Error, /is not a Hash/) }
    end
  end
end
