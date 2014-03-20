require 'rubygems'
require 'logger'
require 'faraday'
require 'json'

require 'alert_logic/version'
require 'alert_logic/log'
require 'alert_logic/utils'
require 'alert_logic/client'
require 'alert_logic/resources'

# Root module methods
module AlertLogic
  @api_client = nil
  @secret_key = nil

  # module api_client and secret_key accessors
  def self.api_client(secret_key = nil, endpoint = nil)
    if @api_client
      if (endpoint && @api_client.endpoint != endpoint) ||
         (secret_key && @api_client.secret_key != secret_key)
        @api_client = nil
      end
    end
    @api_client ||= Client.new(secret_key, endpoint)
  end

  def self.secret_key(secret_key = nil)
    if !@secret_key && secret_key ||
       (@secret_key && secret_key) && (@secret_key != secret_key)
      AlertLogic.api_client(secret_key)
      @secret_key = secret_key
    end
    @secret_key
  end

  def self.secret_key=(secret_key)
    if !secret_key
      @secret_key = nil
      @api_client = nil
    else
      self.secret_key(secret_key)
    end
  end
end
