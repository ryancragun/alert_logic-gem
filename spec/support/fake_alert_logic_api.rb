require 'sinatra/base'

class FakeAlertLogicApi < Sinatra::Base
  get '/api/tm/v1/protectedhosts' do
    api_response 200, 'get_protected_hosts.json'
  end

  get '/api/tm/v1/protectedhosts/*' do
    api_response 200, 'get_protected_host.json'
  end

  get '/api/tm/v1/appliances' do
    api_response 200, 'get_appliances.json'
  end

  get '/api/tm/v1/appliances/*' do
    api_response 200, 'get_appliance.json'
  end

  get '/api/tm/v1/policies' do
    api_response 200, 'get_policies.json'
  end

  get '/api/tm/v1/policies/*' do
    api_response 200, 'get_policy.json'
  end

  post '/api/tm/v1/protectedhosts/*' do
    api_response 200, 'post_protected_host.json'
  end

  private

  def api_response(code, json_file)
    content_type :json
    status code
    File.read(File.expand_path("../json/#{json_file}", __FILE__))
  end
end
