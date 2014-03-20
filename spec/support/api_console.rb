#!/usr/bin/env ruby
lib = File.expand_path('../', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
lib = File.expand_path('../../../lib/', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'faraday'
require 'pry'
require 'alert_logic'
require 'dotenv'

Dotenv.load(File.expand_path('../../../.env', __FILE__))

options = {
  :url => 'https://publicapi.alertlogic.net/api/tm/v1/',
  :ssl => { :verify => false } }
headers = {
  'Accept' => 'application/json',
  'User-Agent'  => "alert_logic gem v#{AlertLogic::VERSION}"
}
@faraday = Faraday.new(options) do |con|
  con.adapter     Faraday.default_adapter
  con.headers     = headers
  con.basic_auth  ENV['SECRET_KEY'], ''
end

AlertLogic.secret_key = ENV['SECRET_KEY']
@client = AlertLogic.api_client

ARGV.clear
puts "\e[H\e[2J"
Pry.config.prompt_name = 'alertlogic'
Pry.config.output = STDOUT
Pry.config.pager = true
Pry.config.hooks.add_hook(:before_session, :set_context) do |_, _, pry|
  pry.input = StringIO.new('cd @client')
end
Pry.start
