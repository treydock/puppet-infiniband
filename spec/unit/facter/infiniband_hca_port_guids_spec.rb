require 'spec_helper'
require 'facter/util/infiniband'

describe 'infiniband_hca_port_guids fact' do
  before :each do
    Facter.clear
    allow(Facter.fact(:has_infiniband)).to receive(:value).and_return(true)
  end

  it 'returns HCAs' do
    allow(Facter.fact(:infiniband_hcas)).to receive(:value).and_return(['mlx5_0', 'mlx5_2'])
    allow(Facter::Util::Infiniband).to receive(:get_hca_port_guids).with('mlx5_0').and_return('1' => '0x506b4b0300cc4348')
    allow(Facter::Util::Infiniband).to receive(:get_hca_port_guids).with('mlx5_2').and_return('1' => '0x506b4b0300cc4342')
    expect(Facter.fact(:infiniband_hca_port_guids).value).to eq('mlx5_0' => { '1' => '0x506b4b0300cc4348' }, 'mlx5_2' => { '1' => '0x506b4b0300cc4342' })
  end

  it 'returns nil for no HCAs' do
    allow(Facter.fact(:infiniband_hcas)).to receive(:value).and_return(nil)
    expect(Facter::Util::Infiniband).not_to receive(:get_hca_port_guids)
    expect(Facter.fact(:infiniband_hca_port_guids).value).to be_nil
  end

  it 'returns empty hash for no ports' do
    allow(Facter.fact(:infiniband_hcas)).to receive(:value).and_return(['mlx5_0', 'mlx5_2'])
    allow(Facter::Util::Infiniband).to receive(:get_hca_port_guids).with('mlx5_0').and_return({})
    allow(Facter::Util::Infiniband).to receive(:get_hca_port_guids).with('mlx5_2').and_return({})
    expect(Facter.fact(:infiniband_hca_port_guids).value).to be_nil
  end
end
