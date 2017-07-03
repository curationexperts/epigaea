require 'solr_wrapper/rake_task'

namespace :epigaea do
  task :spec do
    with_server 'test' do
      Rake::Task['spec'].invoke
    end
  end
end
