# frozen_string_literal: true

require 'spec_helper'
require 'facter/util/infiniband'

describe 'has_infiniband fact' do
  before :each do
    Facter.clear
    allow(Facter.fact(:kernel)).to receive(:value).and_return('Linux')
    allow(Facter::Core::Execution).to receive(:which).with('lspci').and_return('/sbin/lspci')
  end

  it 'returns true when Mellanox ConnectX card' do
    allow(Facter::Util::Infiniband).to receive(:lspci).and_return(my_fixture_read('mellanox_lspci_1'))
    expect(Facter.fact(:has_infiniband).value).to eq(true)
  end

  it 'returns true when QLogic card' do
    allow(Facter::Util::Infiniband).to receive(:lspci).and_return(my_fixture_read('qlogic_lspci_1'))
    expect(Facter.fact(:has_infiniband).value).to eq(true)
  end

  it 'returns false when no IB device present' do
    allow(Facter::Util::Infiniband).to receive(:lspci).and_return(my_fixture_read('noib_lspci_1'))
    expect(Facter.fact(:has_infiniband).value).to eq(false)
  end

  it 'returns true with Mellanox ConnectX-3 card' do
    allow(Facter::Util::Infiniband).to receive(:lspci).and_return(my_fixture_read('mellanox_lspci_2'))
    expect(Facter.fact(:has_infiniband).value).to eq(true)
  end
end
