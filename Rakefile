# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

require 'solr_wrapper/rake_task' unless Rails.env.production?

require 'rubocop/rake_task'
desc 'Run RuboCop style checker'
RuboCop::RakeTask.new(:rubocop) do |t|
  t.fail_on_error = true
end

Dir.glob('lib/tasks/*.rake').each { |r| import r }

task default: :ci

