module AlertLogic
  # JSON parsing HTTP client with some helper methods
  class Client
    include Utils
    include RestMethods

    attr_reader :endpoint, :secret_key

    DEFAULT_ENDPOINT = 'https://publicapi.alertlogic.net/api/tm/v1/'

    def initialize(secret_key = nil, endpoint = nil)
      @secret_key = secret_key  || AlertLogic.secret_key
      @endpoint   = endpoint    || DEFAULT_ENDPOINT
      @logger     = AlertLogic.logger
      init
    end

    def secret_key=(secret_key)
      @secret_key = secret_key
      reload!
      @secret_key
    end

    def endpoint=(endpoint)
      @endpoint = endpoint
      reload!
      @endpoint
    end

    def reload!
      @connection = nil
      init
    end

    private

    def init
      verify_key
      options = { :url => @endpoint,
                  :ssl => { :verify => false }
                }
      headers = { 'Accept'      => 'application/json',
                  'User-Agent'  => "alert_logic gem v#{VERSION}"
                }
      @connection = Faraday.new(options) do |con|
        con.use         Faraday::Response::Logger,  @logger
        con.use         Faraday::Response::RaiseError
        con.adapter     Faraday.default_adapter
        con.headers     = headers
        con.basic_auth  @secret_key, ''
      end
    end

    def verify_key
      unless @secret_key =~ /^[a-fA-F\d]{50}$/
        msg = "#{@secret_key.inspect} is invalid. "
        msg << 'You must supply a valid 50 character secret_key!'
        fail InvalidKey, msg
      end
    end

    def parse_response_for(resource_type, &api_call)
      res = yield(api_call)
      ClientResponse.new(
        res.status,
        normalize_response(resource_type, JSON.parse(res.body))
      )
    rescue => e
      raise ClientError, e.message
    end

    def normalize_response(resource_type, js)
      if js.respond_to?(:key?)
        if js.key?(pluralize(resource_type))
          flatten(resource_type, js[pluralize(resource_type)])
        elsif js.key?(resource_type)
          [js[resource_type]]
        else
          js.first
        end
      elsif js.respond_to?(:empty?) && !js.empty?
        js
      else
        @logger.info "No #{pluralize(resource_type)} found.."
        []
      end
    end

    def flatten(type, resources)
      resources.count >= 1 ? resources.map! { |item| item[type] } : []
    end
  end

  ClientResponse = Struct.new(:status, :body)

  class ClientError < Faraday::Error::ClientError; end
  class InvalidKey < ClientError; end
end
