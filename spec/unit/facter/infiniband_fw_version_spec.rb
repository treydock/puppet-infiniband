require 'spec_helper'

describe 'infiniband_fw_version fact' do
  
  before :each do
    Facter.clear
    Facter.fact(:kernel).stubs(:value).returns("Linux")
    Facter.fact(:has_infiniband).stubs(:value).returns(true)
  end
  
  it "should handle a single mlx port" do
    Facter::Util::Infiniband.stubs(:get_ports).returns(["mlx4_0"])
    Facter::Util::Infiniband.stubs(:get_port_fw_version).with("mlx4_0").returns("2.9.1200")
    Facter.fact(:infiniband_fw_version).value.should == "2.9.1200"
  end

  it "should handle multiple mlx ports" do
    Facter::Util::Infiniband.stubs(:get_ports).returns(["mlx4_0","mlx4_1"])
    Facter::Util::Infiniband.stubs(:get_port_fw_version).with("mlx4_0").returns("2.9.1200")
    Facter.fact(:infiniband_fw_version).value.should == "2.9.1200"
  end
  
  it "should handle a single qib port" do
    Facter::Util::Infiniband.stubs(:get_ports).returns(["qib0"])
    Facter::Util::Infiniband.stubs(:get_port_fw_version).with("qib0").returns("1.11")
    Facter.fact(:infiniband_fw_version).value.should == "1.11"
  end
  
  it "should handle multiple mlx ports" do
    Facter::Util::Infiniband.stubs(:get_ports).returns(["qib0","qib1"])
    Facter::Util::Infiniband.stubs(:get_port_fw_version).with("qib0").returns("1.11")
    Facter.fact(:infiniband_fw_version).value.should == "1.11"
  end

  it "should return nil for unknown port name" do
    Facter::Util::Infiniband.stubs(:get_ports).returns(["foo"])
    Facter::Util::Infiniband.stubs(:get_port_fw_version).with("foo").returns(nil)
    Facter.fact(:infiniband_fw_version).value.should == nil
  end

  it "should return nil if no ports found" do
    Facter::Util::Infiniband.stubs(:get_ports).returns([])
    Facter.fact(:infiniband_fw_version).value.should == nil
  end
end
