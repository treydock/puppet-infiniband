# frozen_string_literal: true

require 'spec_helper'

describe 'infiniband::calc_log_num_mtt' do
  it 'returns 23' do
    is_expected.to run.with_params(135_303_601_848.32).and_return(23)
  end

  it 'returns 22' do
    is_expected.to run.with_params(67_528_032_256.00).and_return(22)
  end

  it 'returns 25' do
    is_expected.to run.with_params(135_303_601_848.32, 1).and_return(25)
  end

  it 'returns 24' do
    is_expected.to run.with_params(67_528_032_256.00, 1).and_return(24)
  end

  it 'handles [undef,1]' do
    is_expected.to run.with_params(nil, 1).and_return(0)
  end

  it 'raises a ParseError if there is more than 3 argument' do
    is_expected.to run.with_params('1', '2', '3', '4').and_raise_error(ArgumentError, %r{expects at most 3 arguments})
  end
end
