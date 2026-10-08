# frozen_string_literal: true

require 'spec_helper'
require 'facter/util/infiniband'

describe 'infiniband_board_id fact' do
  before :each do
    Facter.clear
    allow(Facter.fact(:has_infiniband)).to receive(:value).and_return(true)
  end

  it 'handles a single mlx port' do
    allow(Facter::Util::Infiniband).to receive(:ports).and_return(['mlx4_0'])
    allow(Facter::Util::Infiniband).to receive(:get_port_board_id).with('mlx4_0').and_return('MT_0000000000')
    expect(Facter.fact(:infiniband_board_id).value).to eq('MT_0000000000')
  end

  it 'handles multiple mlx ports' do
    allow(Facter::Util::Infiniband).to receive(:ports).and_return(['mlx4_0', 'mlx4_1'])
    allow(Facter::Util::Infiniband).to receive(:get_port_board_id).with('mlx4_0').and_return('MT_0000000000')
    expect(Facter.fact(:infiniband_board_id).value).to eq('MT_0000000000')
  end

  it 'handles a single qib port' do
    allow(Facter::Util::Infiniband).to receive(:ports).and_return(['qib0'])
    allow(Facter::Util::Infiniband).to receive(:get_port_board_id).with('qib0').and_return('InfiniPath_QLE0000')
    expect(Facter.fact(:infiniband_board_id).value).to eq('InfiniPath_QLE0000')
  end

  it 'handles multiple qib ports' do
    allow(Facter::Util::Infiniband).to receive(:ports).and_return(['qib0', 'qib1'])
    allow(Facter::Util::Infiniband).to receive(:get_port_board_id).with('qib0').and_return('InfiniPath_QLE0000')
    expect(Facter.fact(:infiniband_board_id).value).to eq('InfiniPath_QLE0000')
  end

  it 'returns nil for unknown port name' do
    allow(Facter::Util::Infiniband).to receive(:ports).and_return(['foo'])
    allow(Facter::Util::Infiniband).to receive(:get_port_board_id).with('foo').and_return(nil)
    expect(Facter.fact(:infiniband_board_id).value).to be_nil
  end

  it 'returns nil if no ports found' do
    allow(Facter::Util::Infiniband).to receive(:ports).and_return([])
    expect(Facter.fact(:infiniband_board_id).value).to be_nil
  end
end
