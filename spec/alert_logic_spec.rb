require 'spec_helper'

module AlertLogic
  describe AlertLogic, '.api_client' do
    before(:each) do
      @client = double(:secret_key => '3234', :endpoint => 'https://fake.com')
      AlertLogic.instance_variable_set(:@api_client, @client)
      allow(Client).to receive(:new).and_return(@client)
    end

    it 'accepts no params and returns a client' do
      AlertLogic.instance_variable_set(:@api_client, nil)
      AlertLogic.api_client.should eq(@client)
    end

    it 'accepts a non-matching secret_key param and returns a new client' do
      new_key = '8F1E9F714E7C70DADF5C26BDC89618999E211FA45766279f07'
      Client.should_receive(:new).with(new_key, nil)
      AlertLogic.api_client(new_key)
    end

    it 'accepts a matching secret_key param and returns an existing client' do
      AlertLogic.api_client('3234').should eq(@client)
    end

    it 'accepts a non-matching endpoint param and returns a new client' do
      endpoint = 'https://differentfake.com'
      Client.should_receive(:new).with(nil, endpoint)
      AlertLogic.api_client(nil, endpoint)
    end

    it 'accepts a matching endpoint param and returns an existing client' do
      AlertLogic.api_client(nil, '3234').should eq(@client)
    end

    it 'accepts a non-matching endpoint/key params and returns a new client' do
      endpoint = 'https://differentfake.com'
      new_key = '8F1E9F714E7C70DADF5C26BDC89618999E211FA45766279f07'
      Client.should_receive(:new).with(new_key, endpoint)
      AlertLogic.api_client(new_key, endpoint)
    end

    it 'accepts a matching endpoint param and returns an existing client' do
      AlertLogic.api_client('https://fake.com', '3234').should eq(@client)
    end
  end

  describe AlertLogic, '.secret_key' do
    before(:each) do
      AlertLogic.instance_variable_set(:@secret_key, '1234')
      allow(AlertLogic).to receive(:api_client).with(/\d+/)
    end

    it 'returns nil when not set' do
      AlertLogic.instance_variable_set(:@secret_key, nil)
      AlertLogic.secret_key.should be_nil
    end

    it 'returns a value when set' do
      AlertLogic.secret_key.should_not be_nil
      AlertLogic.secret_key.should eq('1234')
    end

    it 'configures a new api_client when the key doesnt match' do
      AlertLogic.should_receive(:api_client).with('5678')
      AlertLogic.secret_key('5678')
    end

    it 'returns the existing key when the keys match' do
      AlertLogic.secret_key('1234').should eq('1234')
    end
  end

  describe AlertLogic, '.secret_key=' do
    it 'should proxy request to #secret_key' do
      AlertLogic.should_receive(:secret_key)
      AlertLogic.secret_key = '1234'
    end
  end
end
