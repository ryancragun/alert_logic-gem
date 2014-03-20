require 'spec_helper'

module AlertLogic
  describe Client, '.new' do
    before(:each) do
      AlertLogic.secret_key = Test.secret_key
    end

    it 'initializes a new client with no params and a secret_key set' do
      client = Client.new
      client.secret_key.should eq(AlertLogic.secret_key)
    end

    it 'raises an exception when no key is configure or passed' do
      AlertLogic.secret_key = nil
      expect { Client.new }.to raise_error(InvalidKey)
    end

    it 'initializes a new client with a key param' do
      key = '8F1E9F714E7C70DADF5C26BDC89618999E211FA45766279f07'
      client = Client.new(key)
      client.secret_key.should eq(key)
    end

    it 'initializes a new client with an endpoint param' do
      endpoint = 'https://fake.com'
      client = Client.new(nil, endpoint)
      client.endpoint.should eq(endpoint)
    end

    it 'initializes a new client with both params' do
      endpoint = 'https://fake.com'
      key = '8F1E9F714E7C70DADF5C26BDC89618999E211FA45766279f07'
      client = Client.new(key, endpoint)
      client.endpoint.should eq(endpoint)
      client.secret_key.should eq(key)
    end

    it 'creates all the required instance variables' do
      # ruby 1.8.7 can't sort an array of symbols so we have to define <=>
      # to convert them to strings and compare against an array of strings.
      vars = ['@secret_key', '@endpoint', '@logger', '@connection']
      client = Client.new
      client.instance_variables.map(&:to_s).sort \
        .should eq(vars.sort)
      client \
        .instance_variable_get(:@connection) \
        .should be_instance_of(Faraday::Connection)
    end
  end
end
