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
  confine :kernel => "Linux"
  confine :has_infiniband => true
  ports = Facter::Util::Infiniband.get_ports
  if ! ports.empty?
    rate = Facter::Util::Infiniband.get_port_rate(ports.first)
    if rate
      setcode do
        rate[/^(\d+)\s/,1]
      end
    end
  end
end
