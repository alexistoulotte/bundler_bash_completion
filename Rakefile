require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

desc 'Default: runs specs.'
task default: :spec

desc 'Run all specs in spec directory.'
RSpec::Core::RakeTask.new(:spec)
