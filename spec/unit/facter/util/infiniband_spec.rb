require 'spec_helper'
require 'facter/util/file_read'
require 'facter/util/infiniband'

describe Facter::Util::Infiniband do

  before :each do
    Facter.clear
  end

  describe 'lspci' do
    it 'should return output' do
      Facter::Util::Resolution.expects(:exec).with('lspci -n 2>/dev/null').returns("foo")
      Facter::Util::Infiniband.lspci.should == "foo"
    end
  end

  describe 'read_sysfs' do
    it 'should return output' do
      Facter::Util::FileRead.expects(:read).with("/sys/class/infiniband/mlx4_0/fw_ver").returns("2.9.1200\n")
      Facter::Util::Infiniband.read_sysfs("/sys/class/infiniband/mlx4_0/fw_ver").should == "2.9.1200"
    end

    it 'should return nil' do
      Facter::Util::FileRead.expects(:read).with("/sys/class/infiniband/mlx4_0/fw_ver").returns(nil)
      Facter::Util::Infiniband.read_sysfs("/sys/class/infiniband/mlx4_0/fw_ver").should == nil
    end
  end

  describe 'get_port_fw_version' do
    it 'should return fw_ver for mlx devices' do
      Facter::Util::Infiniband.expects(:read_sysfs).with("/sys/class/infiniband/mlx4_0/fw_ver").returns("2.9.1200")
      Facter::Util::Infiniband.get_port_fw_version("mlx4_0").should == "2.9.1200"
    end

    it 'should return nil' do
      Facter::Util::Infiniband.expects(:read_sysfs).with("/sys/class/infiniband/mlx4_0/fw_ver").returns(nil)
      Facter::Util::Infiniband.get_port_fw_version("mlx4_0").should == nil
    end

    it 'should return nil' do
      Facter::Util::Infiniband.expects(:read_sysfs).never
      Facter::Util::Infiniband.get_port_fw_version("foo").should == nil
    end
  end

  describe 'get_port_board_id' do
    it 'should return board_id' do
      Facter::Util::Infiniband.expects(:read_sysfs).with("/sys/class/infiniband/mlx4_0/board_id").returns("MT_0000000000")
      Facter::Util::Infiniband.get_port_board_id("mlx4_0").should == "MT_0000000000"
    end

    it 'should return nil' do
      Facter::Util::Infiniband.expects(:read_sysfs).with("/sys/class/infiniband/mlx4_0/fw_ver").returns(nil)
      Facter::Util::Infiniband.get_port_fw_version("mlx4_0").should == nil
    end
  end

  describe 'get_ports' do
    it "should return a array with single port name" do
      Dir.stubs(:glob).with("/sys/class/infiniband/*").returns(["/sys/class/infiniband/mlx4_0"])
      Facter::Util::Infiniband.get_ports.should == ["mlx4_0"]
    end

    it "should return a array with two port names" do
      Dir.stubs(:glob).with("/sys/class/infiniband/*").returns(["/sys/class/infiniband/mlx4_0","/sys/class/infiniband/mlx4_1"])
      Facter::Util::Infiniband.get_ports.should == ["mlx4_0","mlx4_1"]
    end

    it "should return empty array if no ports exist" do
      Dir.stubs(:glob).with("/sys/class/infiniband/*").returns([])
      Facter::Util::Infiniband.get_ports.should == []
    end
  end

  describe 'get_port_rate' do
    it 'should return rate for DDR device' do
      Dir.expects(:glob).with('/sys/class/infiniband/mlx4_0/ports/*').returns(['/sys/class/infiniband/mlx4_0/ports/1'])
      Facter::Util::Infiniband.expects(:read_sysfs).with("/sys/class/infiniband/mlx4_0/ports/1/rate").returns("20 Gb/sec (4X DDR)")
      Facter::Util::Infiniband.get_port_rate("mlx4_0").should == "20 Gb/sec (4X DDR)"
    end

    it 'should return nil when Dir.glob is empty' do
      Dir.expects(:glob).with('/sys/class/infiniband/mlx4_0/ports/*').returns([])
      Facter::Util::Infiniband.get_port_rate("mlx4_0").should == nil
    end

    it 'should return nil when read_sysfs is nil' do
      Dir.expects(:glob).with('/sys/class/infiniband/mlx4_0/ports/*').returns(['/sys/class/infiniband/mlx4_0/ports/1'])
      Facter::Util::Infiniband.expects(:read_sysfs).with("/sys/class/infiniband/mlx4_0/ports/1/rate").returns(nil)
      Facter::Util::Infiniband.get_port_rate("mlx4_0").should == nil
    end
  end
end
