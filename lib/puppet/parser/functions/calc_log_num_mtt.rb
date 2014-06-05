module Puppet::Parser::Functions
  newfunction(:calc_log_num_mtt, :type => :rvalue, :doc => <<-EOS

    EOS
  ) do |args|

    # Validate the number of args
    if args.size < 0
      raise(Puppet::ParseError, "calc_log_num_mtt(): Takes at least one " +
            "args, but #{args.size} given.")
    end

    if args.size > 3
      raise(Puppet::ParseError, "calc_log_num_mtt(): Takes at most three " +
            "args, but #{args.size} given.")
    end

    mem = args[0].to_i
    log_mtts_per_seg = args[1] || 3
    page_size_bytes = args[2] || 4096

    log_mtts_per_seg_multiplier = 2**log_mtts_per_seg.to_i

    reg_mem = mem * 1024 * 1024 * 2

    result = 0
    i = 1
    while result == 0 do
      target = (2**i) * page_size_bytes.to_i * log_mtts_per_seg_multiplier
      target_next = (2**(i+1)) * page_size_bytes.to_i * log_mtts_per_seg_multiplier

      if target > reg_mem
        break
      elsif target == reg_mem
        result = i
      elsif target < reg_mem and target_next > reg_mem
        result = i + 1
      end

      i += 1
    end

    result
  end
end
