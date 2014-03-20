# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alert_logic/version'
require 'base64'

Gem::Specification.new do |spec|
  spec.name          = 'alert_logic'
  spec.version       = AlertLogic::VERSION
  spec.authors       = ['Ryan Cragun']
  encoded_email      = %w(cnlhbkByaWdodHNjYWxlLmNvbQ==)
  spec.email         = encoded_email.map { |e| Base64.decode64(e) }
  message = %q(A feature rich API client for AlertLogic Threat Manager)
  spec.summary       = message
  spec.description   = message
  spec.homepage      = 'https://github.com/ryancragun/alert_logic-gem'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($ORS)
  spec.executables   = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)/)
  spec.require_paths = %w(lib)

  spec.add_dependency 'json' if RbConfig::CONFIG['ruby_version'].to_f < 1.9
  spec.add_dependency 'faraday'
end
