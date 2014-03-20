#!/usr/bin/env ruby
lib = File.expand_path('../', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
lib = File.expand_path('../../../lib/', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'webmock'
require 'alert_logic'
require 'fake_alert_logic_api'

include WebMock::API

WebMock.disable_net_connect!(:allow_localhost => true)

stub_request(:any, /https:\/\/\h{50}:@publicapi.alertlogic.net\/api\/tm\/v1\//)
  .to_rack(FakeAlertLogicApi)

require 'api_console'
