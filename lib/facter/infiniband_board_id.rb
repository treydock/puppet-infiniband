# frozen_string_literal: true

# Fact: infiniband_board_id
#
# Purpose: Report the board_id of the InfiniBand hardware
#
# Resolution:
#   Returns the board_id (PSID).
#
# Caveats:
#   Only tested on systems with a single InfiniBand device
#

require 'facter/util/infiniband'

Facter.add(:infiniband_board_id) do
  confine has_infiniband: true
  ports = Facter::Util::Infiniband.ports
  unless ports.empty?
    board_id = Facter::Util::Infiniband.get_port_board_id(ports.first)
    if board_id
      setcode do
        board_id
      end
    end
  end
end
