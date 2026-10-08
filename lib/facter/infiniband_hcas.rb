# frozen_string_literal: true

# Fact: infiniband_hcas
#
# Purpose: Determine list of Infiniband HCAs
#
# Resolution:
#   Returns Array of HCA names.
#

require 'facter/util/infiniband'

Facter.add(:infiniband_hcas) do
  confine has_infiniband: true
  setcode do
    hcas = Facter::Util::Infiniband.hcas
    if hcas.empty?
      nil
    else
      hcas
    end
  end
end
