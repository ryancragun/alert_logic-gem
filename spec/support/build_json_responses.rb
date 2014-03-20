#!/usr/bin/env ruby
lib = File.expand_path('../../../lib/', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'dotenv'
require 'faraday'
require 'json'
require 'pry-debugger'
require 'logger'

Dotenv.load(File.expand_path('../../../.env', __FILE__))

def pluralize(resource)
  resource =~ /^\w+y$/ ? resource.sub(/y$/, 'ies') : "#{resource}s"
end

options = {
  :url => 'https://publicapi.alertlogic.net/api/tm/v1/',
  :ssl => { :verify => false } }
headers = {
  'Accept' => 'application/json',
  'User-Agent'  => 'alert_logic gem TEST'
}
@client = Faraday.new(options) do |con|
  con.use         Faraday::Response::Logger, Logger.new($stdout)
  con.use         Faraday::Response::RaiseError
  con.adapter     Faraday.default_adapter
  con.headers     = headers
  con.basic_auth  ENV['SECRET_KEY'], ''
end

# Get requests don't change resources so we'll gather them all together
get_resources = [
  ['protectedhost', nil,                    {}, 'get_protected_hosts.json'],
  ['protectedhost', ENV['PROTECTED_HOST'],  {}, 'get_protected_host.json'],
  ['policy',        nil,                    {}, 'get_policies.json'],
  ['policy',        ENV['POLICY'],          {}, 'get_policy.json'],
  ['appliance',     nil,                    {}, 'get_appliances.json'],
  ['appliance',     ENV['APPLIANCE'],       {}, 'get_appliance.json']
]

get_resources.each do |r|
  File.open(File.expand_path("../json/#{r[3]}", __FILE__), 'w') do |file|
    res = @client.get do |req|
      req.url r[1] ? "#{pluralize(r[0])}/#{r[1]}" : pluralize(r[0])
      r[2].each { |k, v| req.params[k] = v }
    end
    file.write(res.body)
  end
end

# TODO: automate post requests for testing

# Post requests change resources so we'll intentionall post existing values
# to prevent actually modifying policies

# protected_host_
# post_resource = [
#  ['protectedhost', ENV['PROTECTED_HOST'],
