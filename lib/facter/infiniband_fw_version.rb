# frozen_string_literal: true

# Fact: infiniband_fw_version
#
# Purpose: Report the version of the InfiniBand hardware
#
# Resolution:
#   Returns InfiniBand device FW Version
#
# Caveats:
#   Only tested on systems with a single InfiniBand device
#

require 'facter/util/infiniband'

Facter.add(:infiniband_fw_version) do
  confine has_infiniband: true
  ports = Facter::Util::Infiniband.ports
  unless ports.empty?
    fw_version = Facter::Util::Infiniband.get_port_fw_version(ports.first)
    if fw_version
      setcode do
        fw_version
      end
    end
  end
end
