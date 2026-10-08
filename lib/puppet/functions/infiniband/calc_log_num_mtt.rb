# frozen_string_literal: true

# This function calculates the appropriate value for mlx4_core module's `log_num_mtt` parameter.
#
# The formula is `max_reg_mem = (2^log_num_mtt) * (2^log_mtts_per_seg) * (page_size_bytes)`.  This function finds the
# log_num_mtt necessary to make 'max_reg_mem' twice the size of system's RAM.  Ref: http://community.mellanox.com/docs/DOC-1120.
Puppet::Functions.create_function(:'infiniband::calc_log_num_mtt') do
  # @param mem The system memory in bytes
  # @param log_mtts_per_seg The value for log_mtts_per_seg.  Defaults to `3` if undefined.
  # @param page_size_bytes The system's page size in bytes.  Defaults to `4096` if undefined.
  # @return [Integer] The calculated log_num_mtt value
  # @example Using system memory size to calculate value
  #   infiniband::calc_log_num_mtt($facts['memory']['system']['total_bytes'])
  dispatch :calc do
    optional_param 'Variant[Undef,Integer,Float]', :mem
    optional_param 'Integer', :log_mtts_per_seg
    optional_param 'Integer', :page_size_bytes
  end

  def calc(mem = 0, log_mtts_per_seg = 3, page_size_bytes = 4096)
    return 0 if mem.nil?

    log_mtts_per_seg_multiplier = 2**log_mtts_per_seg.to_i

    reg_mem = mem * 2

    result = 0
    i = 1
    while result.zero?
      target = (2**i) * page_size_bytes.to_i * log_mtts_per_seg_multiplier
      target_next = (2**(i + 1)) * page_size_bytes.to_i * log_mtts_per_seg_multiplier

      break if target > reg_mem

      if target == reg_mem
        result = i
      elsif target < reg_mem && target_next > reg_mem
        result = i + 1
      end

      i += 1
    end

    result
  end
end
