# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "chico"
  gem.homepage = "http://github.com/ConduitTeam/chico"
  gem.license = "Apache2"
  gem.summary = %Q{Fetch favicons}
  gem.email = "elad.kehat@conduit.com"
  gem.authors = ["Elad Kehat", 'Ben Aviram']
  ["gogetter",["nokogiri", "~> 1.5.0"], "chunky_png"].each do |dep|
    gem.add_dependency *dep
  end
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
