require 'rake'

namespace :tufts do
  namespace :handle do
    desc 'Registers a handle for the object. Supply an id.'
    task :register, [:id] => :environment do |_, args|
      begin
        object = ActiveFedora::Base.find(args[:id])
      rescue ActiveFedora::ObjectNotFoundError
        $stderr.puts "Unable to find the object for #{args[:id]}"
        next
      end

      if object.identifier.empty?
        handle = Tufts::HandleDispatcher.assign_for!(object: object)
        object.save!
        puts "Registered a handle #{handle} for #{args[:id]}"
      else
        puts "Identifier(s) exist for #{args[:id]}: #{object.identifier}"
      end
    end
  end
end
