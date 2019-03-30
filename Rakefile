# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'

class ExampleAppCommand
  class << self
    def run(command)
      new(command).run
    end
  end

  def initialize(command)
    @command = command
    example_app = ENV['EXAMPLE_APP'] || 'demo_app'
    @example_app_path = File.expand_path("./examples/#{example_app}", __dir__)
    @gemfile_path = File.join(@example_app_path, 'Gemfile')
  end

  def run
    print_description

    specific_gemfile_env = Bundler.clean_env
    specific_gemfile_env['BUNDLE_GEMFILE'] = @gemfile_path

    Bundler.send(:with_env, specific_gemfile_env) do
      exit_status_was_zero = system("cd #{@example_app_path} && #{@command}")
      raise unless exit_status_was_zero
    end
  end

  def print_description
    puts '---------------------',
         "Gemfile: #{@gemfile_path}",
         "Directory: #{@example_app_path}",
         "Command: '#{@command}'",
         '---------------------'
  end
end

namespace :test do
  desc 'Run unit tests'
  Rake::TestTask.new(:unit) do |t|
    t.libs << 'test'
    t.libs << 'lib'
    t.test_files =
      FileList['test/**/*_test.rb'].exclude('test/integration/**/*')
  end

  desc 'Run integration tests in example app'
  task :integration do
    ExampleAppCommand.run('bundle exec rake test')
  end

  namespace :integration do
    desc 'Resolve and install dependencies and build assets in example app'
    task :prepare do
      ExampleAppCommand.run('bundle check || bundle install')
      ExampleAppCommand.run('bin/yarn')
      ExampleAppCommand.run('bin/yarn build')
    end
  end
end

task test: ['test:unit', 'test:integration']

task default: :test
