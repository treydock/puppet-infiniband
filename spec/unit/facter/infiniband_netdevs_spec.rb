# frozen_string_literal: true

require 'spec_helper'
require 'facter/util/infiniband'

describe 'infiniband_netdevs fact' do
  before :each do
    Facter.clear
    allow(Facter.fact(:has_infiniband)).to receive(:value).and_return(true)
  end

  it 'returns HCAs' do
    allow(Facter::Util::Infiniband).to receive(:netdev_to_hcaport).and_return('ib0' => { 'hca' => 'mlx5_0' })
    expect(Facter.fact(:infiniband_netdevs).value).to eq('ib0' => { 'hca' => 'mlx5_0' })
  end

  it 'returns nil for no HCAs' do
    allow(Facter::Util::Infiniband).to receive(:netdev_to_hcaport).and_return({})
    expect(Facter.fact(:infiniband_netdevs).value).to be_nil
  end
end
