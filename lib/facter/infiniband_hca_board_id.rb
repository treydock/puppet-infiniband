# frozen_string_literal: true

# Fact: infiniband_hca_board_id
#
# Purpose: Determine the board ID of HCA
#
# Resolution:
#   Returns Hash of HCAs and their board ID.
#

require 'facter/util/infiniband'

Facter.add(:infiniband_hca_board_id) do
  confine has_infiniband: true
  setcode do
    hcas = Facter.fact(:infiniband_hcas).value || []
    hca_board_id = {}
    hcas.each do |hca|
      board_id = Facter::Util::Infiniband.get_hca_board_id(hca)
      hca_board_id[hca] = board_id
    end
    if hca_board_id.empty?
      nil
    else
      hca_board_id
    end
  end
end
