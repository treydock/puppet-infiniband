require 'spec_helper'

describe Puppet::Parser::Functions.function(:calc_log_num_mtt) do

  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  subject do
    function_name = Puppet::Parser::Functions.function(:calc_log_num_mtt)
    scope.method(function_name)
  end

  it 'should exist' do
    Puppet::Parser::Functions.function('calc_log_num_mtt').should == "function_calc_log_num_mtt"
  end

  it 'should return 23 when args [129035.57]' do
    subject.call(['129035.57']).should == 23
  end

  it 'should return 22 when args [64399.75]' do
    subject.call(['64399.75']).should == 22
  end

  it 'should return 25 when args [129035.57,1]' do
    subject.call(['129035.57','1']).should == 25
  end

  it 'should return 24 when args [64399.75,1]' do
    subject.call(['64399.75','1']).should == 24
  end

  it 'should handle [undef,1]' do
    subject.call([nil,'1']).should == 0
  end

  it 'should raise a ParseError if there is less than 1 argument' do
    expect { subject.call([]).to raise_error(Puppet::ParseError, /Takes at least one args, but 0 given./) }
  end
  
  it 'should raise a ParseError if there is more than 3 argument' do
    expect { subject.call(['1','2','3','4']).to raise_error(Puppet::ParseError, /Takes at most three args, but 4 given./) }
  end
end
