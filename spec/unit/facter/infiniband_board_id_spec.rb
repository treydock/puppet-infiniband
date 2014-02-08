require 'spec_helper'

describe 'infiniband_board_id fact' do
  
  before :each do
    Facter.clear
    Facter.fact(:kernel).stubs(:value).returns("Linux")
    Facter.fact(:has_infiniband).stubs(:value).returns(true)
  end
  
  it "should handle a single mlx port" do
    Facter::Util::Infiniband.stubs(:get_ports).returns(["mlx4_0"])
    Facter::Util::Infiniband.stubs(:get_port_board_id).with("mlx4_0").returns("MT_0000000000")
    Facter.fact(:infiniband_board_id).value.should == "MT_0000000000"
  end

  it "should handle multiple mlx ports" do
    Facter::Util::Infiniband.stubs(:get_ports).returns(["mlx4_0","mlx4_1"])
    Facter::Util::Infiniband.stubs(:get_port_board_id).with("mlx4_0").returns("MT_0000000000")
    Facter.fact(:infiniband_board_id).value.should == "MT_0000000000"
  end
  
  it "should handle a single qib port" do
    Facter::Util::Infiniband.stubs(:get_ports).returns(["qib0"])
    Facter::Util::Infiniband.stubs(:get_port_board_id).with("qib0").returns("InfiniPath_QLE0000")
    Facter.fact(:infiniband_board_id).value.should == "InfiniPath_QLE0000"
  end
  
  it "should handle multiple mlx ports" do
    Facter::Util::Infiniband.stubs(:get_ports).returns(["qib0","qib1"])
    Facter::Util::Infiniband.stubs(:get_port_board_id).with("qib0").returns("InfiniPath_QLE0000")
    Facter.fact(:infiniband_board_id).value.should == "InfiniPath_QLE0000"
  end

  it "should return nil for unknown port name" do
    Facter::Util::Infiniband.stubs(:get_ports).returns(["foo"])
    Facter::Util::Infiniband.stubs(:get_port_board_id).with("foo").returns(nil)
    Facter.fact(:infiniband_board_id).value.should == nil
  end

  it "should return nil if no no ports found" do
    Facter::Util::Infiniband.stubs(:get_ports).returns([])
    Facter.fact(:infiniband_board_id).value.should == nil
  end
end
