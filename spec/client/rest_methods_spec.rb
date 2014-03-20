require 'spec_helper'

module AlertLogic
  describe RestMethods, :env do
    let(:client) { AlertLogic.api_client(Test.secret_key) }

    Test.all_resources.each do |resource, id|
      describe '.delete' do
        it 'interpolates the params and calls the proper client method' do
          client.should_receive(:delete).with('resource', 'resource_id')
          client.delete('resource', 'resource_id')
        end
      end

      describe '.get' do
        it 'interpolates the params and calls the proper client method' do
          client.should_receive(:get).with(resource, id)
          client.get(resource, id)
        end

        it "properly parses #{resource} index" do
          res = client.get(resource, nil)
          expect(res.body).to be_instance_of(Array)
          expect(res.status).to eq(200)
        end

        it "properly parses a singular #{resource}" do
          res = client.get(resource, id)
          res.body.first['id'].should eq(id)
        end
      end

      describe '.put' do
        it 'interpolates the params and calls the proper client method' do
          client.should_receive(:put).with('resource', 'resource_id')
          client.put('resource', 'resource_id')
        end
      end

      describe '.post' do
        it 'interpolates the params and calls the proper client method' do
          client.should_receive(:post).with('resource', 'resource_id')
          client.post('resource', 'resource_id')
        end
      end
    end
  end
end
