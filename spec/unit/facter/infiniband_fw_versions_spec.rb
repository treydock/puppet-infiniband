# frozen_string_literal: true

require 'spec_helper'
require 'facter/util/infiniband'

describe 'infiniband_fw_versions fact' do
  before :each do
    Facter.clear
    allow(Facter.fact(:has_infiniband)).to receive(:value).and_return(true)
  end

  it 'returns hash with single mlx port firmware version' do
    allow(Facter::Util::Infiniband).to receive(:ports).and_return(['mlx4_0'])
    allow(Facter::Util::Infiniband).to receive(:get_port_fw_version).with('mlx4_0').and_return('2.9.1200')
    expect(Facter.fact(:infiniband_fw_versions).value).to eq('mlx4_0' => '2.9.1200')
  end

  it 'returns hash with multiple mlx ports firmware versions' do
    allow(Facter::Util::Infiniband).to receive(:ports).and_return(['mlx4_0', 'mlx4_1'])
    allow(Facter::Util::Infiniband).to receive(:get_port_fw_version).with('mlx4_0').and_return('2.9.1200')
    allow(Facter::Util::Infiniband).to receive(:get_port_fw_version).with('mlx4_1').and_return('2.9.1201')
    expect(Facter.fact(:infiniband_fw_versions).value).to eq('mlx4_0' => '2.9.1200', 'mlx4_1' => '2.9.1201')
  end

  it 'returns hash with single qib port firmware version' do
    allow(Facter::Util::Infiniband).to receive(:ports).and_return(['qib0'])
    allow(Facter::Util::Infiniband).to receive(:get_port_fw_version).with('qib0').and_return('1.11')
    expect(Facter.fact(:infiniband_fw_versions).value).to eq('qib0' => '1.11')
  end

  it 'returns hash with multiple qib ports firmware versions' do
    allow(Facter::Util::Infiniband).to receive(:ports).and_return(['qib0', 'qib1'])
    allow(Facter::Util::Infiniband).to receive(:get_port_fw_version).with('qib0').and_return('1.11')
    allow(Facter::Util::Infiniband).to receive(:get_port_fw_version).with('qib1').and_return('1.12')
    expect(Facter.fact(:infiniband_fw_versions).value).to eq('qib0' => '1.11', 'qib1' => '1.12')
  end

  it 'returns hash with mixed mlx and qib ports firmware versions' do
    allow(Facter::Util::Infiniband).to receive(:ports).and_return(['mlx4_0', 'qib0'])
    allow(Facter::Util::Infiniband).to receive(:get_port_fw_version).with('mlx4_0').and_return('2.9.1200')
    allow(Facter::Util::Infiniband).to receive(:get_port_fw_version).with('qib0').and_return('1.11')
    expect(Facter.fact(:infiniband_fw_versions).value).to eq('mlx4_0' => '2.9.1200', 'qib0' => '1.11')
  end

  it 'skips ports with nil firmware version' do
    allow(Facter::Util::Infiniband).to receive(:ports).and_return(['mlx4_0', 'mlx4_1'])
    allow(Facter::Util::Infiniband).to receive(:get_port_fw_version).with('mlx4_0').and_return('2.9.1200')
    allow(Facter::Util::Infiniband).to receive(:get_port_fw_version).with('mlx4_1').and_return(nil)
    expect(Facter.fact(:infiniband_fw_versions).value).to eq('mlx4_0' => '2.9.1200')
  end

  it 'returns nil if no ports found' do
    allow(Facter::Util::Infiniband).to receive(:ports).and_return([])
    expect(Facter.fact(:infiniband_fw_versions).value).to be_nil
  end

  it 'returns nil if all ports have nil firmware version' do
    allow(Facter::Util::Infiniband).to receive(:ports).and_return(['mlx4_0', 'mlx4_1'])
    allow(Facter::Util::Infiniband).to receive(:get_port_fw_version).with('mlx4_0').and_return(nil)
    allow(Facter::Util::Infiniband).to receive(:get_port_fw_version).with('mlx4_1').and_return(nil)
    expect(Facter.fact(:infiniband_fw_versions).value).to be_nil
  end

  it 'handles unknown port names that return nil firmware' do
    allow(Facter::Util::Infiniband).to receive(:ports).and_return(['foo'])
    allow(Facter::Util::Infiniband).to receive(:get_port_fw_version).with('foo').and_return(nil)
    expect(Facter.fact(:infiniband_fw_versions).value).to be_nil
  end
end
