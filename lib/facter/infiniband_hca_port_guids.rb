# frozen_string_literal: true

# Fact: infiniband_hca_port_guids
#
# Purpose: Determine list of Infiniband HCA port GUIDs
#
# Resolution:
#   Returns Hash of HCA port's and their GUIDs.
#

require 'facter/util/infiniband'

Facter.add(:infiniband_hca_port_guids) do
  confine has_infiniband: true
  setcode do
    hcas = Facter.fact(:infiniband_hcas).value || []
    hca_port_guids = {}
    hcas.each do |hca|
      port_guids = Facter::Util::Infiniband.get_hca_port_guids(hca)
      unless port_guids.empty?
        hca_port_guids[hca] = port_guids
      end
    end
    if hca_port_guids.empty?
      nil
    else
      hca_port_guids
    end
  end
end
