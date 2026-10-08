# frozen_string_literal: true

# Fact: has_infiniband
#
# Purpose: Determine if the system's hardware supports InfiniBand.
#
# Resolution:
#   Returns true or false based on output from `lspci`.
#
# Caveats:
#   Currently only tested with Mellanox and Qlogic cards installed in a system.
#

require 'facter/util/infiniband'

Facter.add(:has_infiniband) do
  confine kernel: 'Linux'
  setcode do
    ib_device_count = Facter::Util::Infiniband.count_ib_devices
    ib_device_count.positive?
  end
end
