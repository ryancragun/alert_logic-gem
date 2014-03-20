require 'spec_helper'

describe AlertLogic, '.logger' do
  before(:each) do
    AlertLogic.logger = nil
    @logger = AlertLogic.logger
  end

  context 'defaults' do
    subject { @logger }
    it { should be_instance_of(Logger) }
    it { should_not be_nil }
    # ensure that it returns the same instance every time
    3.times { it { should be(AlertLogic.logger) } }
  end

  it 'should accept a file path and return a Logger instance' do
    logger = AlertLogic.logger('/tmp/file')
    logger.should be_instance_of(Logger)
    logger.instance_variable_get(:@logdev).filename.should eq('/tmp/file')
  end

  it 'should automaticall use Chefs logger if present' do
    module Chef; module Log; def logger; end; end; end
    chef_log = double
    Chef::Log.stub(:logger).and_return(chef_log)
    AlertLogic.logger = nil
    AlertLogic.logger.should be(chef_log)
  end

  it 'should accept and set an instance as the logger' do
    log = Logger.new($stdout)
    AlertLogic.logger = log
    AlertLogic.logger.should eq(log)
  end
end
