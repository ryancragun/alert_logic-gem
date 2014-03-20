module AlertLogic
  # RestMethods mixin for Client class
  module RestMethods
    # Standard REST methods
    def delete(resource_type, resource_id)
      parse_response_for(resource_type) do
        @connection.delete do |request|
          request.url "#{pluralize(resource_type)}/#{resource_id}"
        end
      end
    end

    def get(resource_type, resource_id, params = {})
      parse_response_for(resource_type) do
        base_url = pluralize(resource_type)
        @connection.get do |request|
          request.url resource_id ? "#{base_url}/#{resource_id}" : base_url
          params.each { |k, v| request.params[k] = v }
        end
      end
    end

    def post(resource_type, resource_id, payload)
      parse_response_for(resource_type) do
        base_url = pluralize(resource_type)
        @connection.post do |request|
          request.url resource_id ? "#{base_url}/#{resource_id}" : base_url
          request.body = payload.to_json
          request.headers['Content-Type'] = 'application/json'
        end
      end
    end

    def put(resource_type, resource_id, payload)
      parse_response_for(resource_type) do
        @connection.put do |request|
          request.url "#{pluralize(resource_type)}/#{resource_id}"
          request.body = payload.to_json
          request.headers['Content-Type'] = 'application/json'
        end
      end
    end

    # REST method wrappers from AlertLogic API Documentation
    # https://developer.alertlogic.net/docs/iodocs/tm
    alias_method :retrieve, :get
    alias_method :edit, :post
    alias_method :replace, :put

    def list(resource_type, params = {})
      get(resource_type, nil, params)
    end

    def create(resource_type, payload)
      post(resource_type, nil, payload)
    end
  end
end
