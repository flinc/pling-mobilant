require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
require 'yard'

RSpec::Core::RakeTask.new(:spec)

YARD::Rake::YardocTask.new(:doc)

task :default => :spec

desc "Open an irb session"
task :console do
  sh "bundle exec irb -rubygems -I lib -r pling/gateway/mobilant.rb"
end