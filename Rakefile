#!/usr/bin/env rake

require 'rake'
require 'rspec'
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

namespace :test do
  desc 'Run spec suite'
  RSpec::Core::RakeTask.new(:spec) do |task|
    task.pattern = FileList['spec/**/*_spec.rb']
  end

  desc 'Build canned JSON responses'
  task :build_json do
    ruby 'spec/support/build_json_responses.rb'
  end

  desc 'Load fake API console'
  task :console do
    ruby 'spec/support/fake_api_console.rb'
  end

  if RUBY_VERSION !~ /^1\.8\..$/
    require 'rubocop/rake_task'

    desc 'Run Rubocop style checks'
    Rubocop::RakeTask.new do |cop|
      cop.fail_on_error = true
    end
  end
end

if RUBY_VERSION !~ /^1\.8\..$/
  desc 'Default task to run spec suite'
  task  :default => ['test:spec', 'test:rubocop']
else
  desc 'Default task to run spec suite'
  task  :default => ['test:spec']
end

desc 'Load API console'
task :console do
  ruby 'spec/support/api_console.rb'
end
