class Facter::Util::Infiniband
  LSPCI_IB_REGEX = [ 
    /^([[:xdigit:]]{2}:[[:xdigit:]]{2}\.\d)\sInfiniBand \[0c06\].*$/,
    /^([[:xdigit:]]{2}:[[:xdigit:]]{2}\.\d)\sNetwork controller \[0280\].*$/
  ]

  # Returns the number of InfiniBand interfaces found
  # in lspci output
  #
  # @return [Integer]
  #
  # @api private
  def self.count_ib_devices
    self.get_device_ids.length
  end

  # Returns the PCI device ID of the InfiniBand interface card
  #
  # @return [String]
  #
  # @api private
  def self.get_device_ids
    if Facter::Util::Resolution.which('lspci')
      lspci = Facter::Util::Resolution.exec('lspci -nn')
      matches = Array.new
      LSPCI_IB_REGEX.each do |regex|
        matches = matches + lspci.scan(regex)
      end
      matches.flatten
    end
  end

  # Returns the firmware version of the InfiniBand interface card
  #
  # @return [String]
  #
  # @api private
  def self.get_fw_versions
    device_ids = Facter::Util::Infiniband.get_device_ids
    return nil unless device_ids

    if Facter::Util::Resolution.which('mstflint')
      fw_versions = Array.new
      device_ids.each do |device_id|
        output = Facter::Util::Resolution.exec("mstflint -device #{device_id} -qq query")
        return nil unless output
        matches = output.scan(/^FW Version:\s+([0-9\.]+)$/m)
        fw_versions << matches.flatten.reject { |o| o.nil? }.first
      end
      return fw_versions
    end
  end
end
