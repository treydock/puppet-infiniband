# frozen_string_literal: true

# Fact: infiniband_rate
#
# Purpose: Report the rate of the InfiniBand interface
#
# Resolution:
#   Returns the rate string from /sys/class/infiniband/*/ports/*/rate.
#
# Caveats:
#   Only tested on systems with a single InfiniBand device
#

require 'facter/util/infiniband'

Facter.add(:infiniband_rate) do
  confine has_infiniband: true
  ports = Facter::Util::Infiniband.ports
  unless ports.empty?
    rate = Facter::Util::Infiniband.get_port_rate(ports.first)
    if rate
      setcode do
        rate[%r{^(\d+)\s}, 1]
      end
    end
  end
end
