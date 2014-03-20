require 'rubygems'
require 'bundler/setup'
require 'alert_logic'
require 'dotenv'
require 'webmock/rspec'

require 'support/fake_alert_logic_api'

WebMock.disable_net_connect!(:allow_localhost => true)
Dotenv.load

def setup_policy
  @rspec_policy = AlertLogic::Policy.find_by_id(ENV['POLICY'])
end

def setup_protected_host
  @rspec_protected_host =
    AlertLogic::Protected_host.find_by_id(ENV['PROTECTED_HOST'])
end

def setup_appliance
  @rspec_appliance = AlertLogic::Appliance.find_by_id(ENV['APPLIANCE'])
end

module Test
  class << self
    attr_reader :appliance_name, :appliance_id
    attr_reader :protected_host_name, :protected_host_id
    attr_reader :policy_name, :policy_id
    attr_reader :secret_key, :all_resources
  end
  @appliance_name = ENV['APPLIANCE_NAME']
  @appliance_id = ENV['APPLIANCE']
  @policy_name = ENV['POLICY_NAME']
  @policy_id = ENV['POLICY']
  @protected_host_name = ENV['PROTECTED_HOST_NAME']
  @protected_host_id = ENV['PROTECTED_HOST']
  @secret_key = ENV['SECRET_KEY']
  @all_resources =
    { 'protectedhost' => @protected_host_id,
      'appliance'     => @appliance_id,
      'policy'        => @policy_id
    }
end

def setup_all
  setup_env
  setup_policy
  setup_protected_host
  setup_appliance
end

RSpec.configure do |rspec|
  rspec.treat_symbols_as_metadata_keys_with_true_values = true
  rspec.run_all_when_everything_filtered = true
  rspec.filter_run :focus
  rspec.order = 'random'

  rspec.before(:each) do
    stub_request(:any, %r{publicapi.alertlogic.net/api/tm/v1/})\
      .to_rack(FakeAlertLogicApi)
  end

  # @example Create case hooks to setup common env in the before block
  # describe "it configures a new Appliance", :env do
  #   it "has a matching id"  do
  #     @rspec_appliance.id.should eq(ENV['APPLIANCE'])
  #   end
  # end
  [:protected_host, :appliance, :policy, :all].each do |hook|
    rspec.before(:each, hook => true) do
      eval("setup_#{hook.to_s}")
    end
  end

  rspec.after(:all) do
    AlertLogic.instance_variable_set(:@api_client, nil)
    AlertLogic.instance_variable_set(:@secret_key, nil)
  end
end
