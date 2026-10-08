# frozen_string_literal: true

require 'spec_helper'
require 'facter/util/infiniband'

describe 'infiniband_hcas fact' do
  before :each do
    Facter.clear
    allow(Facter.fact(:has_infiniband)).to receive(:value).and_return(true)
  end

  it 'returns HCAs' do
    allow(Facter::Util::Infiniband).to receive(:hcas).and_return(['mlx5_0', 'mlx5_1'])
    expect(Facter.fact(:infiniband_hcas).value).to eq(['mlx5_0', 'mlx5_1'])
  end

  it 'returns nil for no HCAs' do
    allow(Facter::Util::Infiniband).to receive(:hcas).and_return([])
    expect(Facter.fact(:infiniband_hcas).value).to be_nil
  end
end
