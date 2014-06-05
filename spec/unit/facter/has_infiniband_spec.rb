require 'spec_helper'

describe 'has_infiniband fact' do

  before :each do
    Facter.clear
    Facter.fact(:kernel).stubs(:value).returns("Linux")
    Facter::Util::Resolution.stubs(:which).with("lspci").returns("/sbin/lspci")
  end

  it "should return true when Mellanox ConnectX card" do
    Facter::Util::Infiniband.stubs(:lspci).returns(my_fixture_read('mellanox_lspci_1'))
    Facter.fact(:has_infiniband).value.should == true
  end

  it "should return true when QLogic card" do
    Facter::Util::Infiniband.stubs(:lspci).returns(my_fixture_read('qlogic_lspci_1'))
    Facter.fact(:has_infiniband).value.should == true
  end

  it "should return false when no IB device present" do
    Facter::Util::Infiniband.stubs(:lspci).returns(my_fixture_read('noib_lspci_1'))
    Facter.fact(:has_infiniband).value.should == false
  end

  it "should return true with Mellanox ConnectX-3 card" do
    Facter::Util::Infiniband.stubs(:lspci).returns(my_fixture_read('mellanox_lspci_2'))
    Facter.fact(:has_infiniband).value.should == true
  end
end
