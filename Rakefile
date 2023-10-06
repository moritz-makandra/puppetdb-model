require 'yard'
require 'fileutils'
require 'bundler'
require 'rubocop/rake_task'

Bundler::GemHelper.install_tasks

YARD::Rake::YardocTask.new('docs:generate')

RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-rake'
end

namespace :docs do
  desc 'Run YARD server'
  task :serve do
    YARD::CLI::Server.run('--refresh')
  end
end


desc 'Cleanup'
task :cleanup do
  FileUtils.rm_rf('docs')
  FileUtils.rm_rf('.yardoc')
end
