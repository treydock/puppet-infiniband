# frozen_string_literal: true

require 'spec_helper'
require 'facter/util/infiniband'

describe 'infiniband_hca_board_id fact' do
  before :each do
    Facter.clear
    allow(Facter.fact(:has_infiniband)).to receive(:value).and_return(true)
  end

  it 'returns HCAs' do
    allow(Facter.fact(:infiniband_hcas)).to receive(:value).and_return(['mlx5_0', 'mlx5_2'])
    allow(Facter::Util::Infiniband).to receive(:get_hca_board_id).with('mlx5_0').and_return('DEL0000000005')
    allow(Facter::Util::Infiniband).to receive(:get_hca_board_id).with('mlx5_2').and_return('DEL0000000005')
    expect(Facter.fact(:infiniband_hca_board_id).value).to eq('mlx5_0' => 'DEL0000000005', 'mlx5_2' => 'DEL0000000005')
  end

  it 'returns nil for no HCAs' do
    allow(Facter.fact(:infiniband_hcas)).to receive(:value).and_return(nil)
    expect(Facter::Util::Infiniband).not_to receive(:get_hca_board_id)
    expect(Facter.fact(:infiniband_hca_board_id).value).to be_nil
  end

  it 'returns nil board_id' do
    allow(Facter.fact(:infiniband_hcas)).to receive(:value).and_return(['mlx5_0', 'mlx5_2'])
    allow(Facter::Util::Infiniband).to receive(:get_hca_board_id).with('mlx5_0').and_return('DEL0000000005')
    allow(Facter::Util::Infiniband).to receive(:get_hca_board_id).with('mlx5_2').and_return(nil)
    expect(Facter.fact(:infiniband_hca_board_id).value).to eq('mlx5_0' => 'DEL0000000005', 'mlx5_2' => nil)
  end
end
