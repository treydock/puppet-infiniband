# frozen_string_literal: true

require 'spec_helper'
require 'facter/util/infiniband'

describe 'infiniband_rate fact' do
  before :each do
    Facter.clear
    allow(Facter.fact(:has_infiniband)).to receive(:value).and_return(true)
  end

  it 'handles a single port' do
    allow(Facter::Util::Infiniband).to receive(:ports).and_return(['mlx4_0'])
    allow(Facter::Util::Infiniband).to receive(:get_port_rate).with('mlx4_0').and_return('20 Gb/sec (4X DDR)')
    expect(Facter.fact(:infiniband_rate).value).to eq('20')
  end

  it 'handles multiple ports' do
    allow(Facter::Util::Infiniband).to receive(:ports).and_return(['mlx4_0', 'mlx4_1'])
    allow(Facter::Util::Infiniband).to receive(:get_port_rate).with('mlx4_0').and_return('20 Gb/sec (4X DDR)')
    expect(Facter.fact(:infiniband_rate).value).to eq('20')
  end

  it 'returns nil for unknown port name' do
    allow(Facter::Util::Infiniband).to receive(:ports).and_return(['foo'])
    allow(Facter::Util::Infiniband).to receive(:get_port_rate).with('foo').and_return(nil)
    expect(Facter.fact(:infiniband_rate).value).to be_nil
  end

  it 'returns nil if no ports found' do
    allow(Facter::Util::Infiniband).to receive(:ports).and_return([])
    expect(Facter.fact(:infiniband_rate).value).to be_nil
  end
end
