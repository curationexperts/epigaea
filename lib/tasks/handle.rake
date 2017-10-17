require 'rake'

namespace :tufts do
  namespace :handle do
    ##
    # @example using control-flow-or to exit a rake task when no object is found
    #   object = find_or_warn('not_an_id') || next
    #
    # @param id [String]
    # @return [ActiveFedora::Base, false]
    def find_or_warn(id)
      ActiveFedora::Base.find(id)
    rescue ActiveFedora::ObjectNotFoundError
      $stderr.puts "Unable to find an ActiveFedora::Base object for id: #{id}"
      false
    end

    desc 'Registers a handle for the object. Supply an id.'
    task :register, [:id] => :environment do |_, args|
      object = find_or_warn(args[:id]) || next

      if object.identifier.empty?
        handle = Tufts::HandleDispatcher.assign_for!(object: object)
        object.save!
        puts "Registered a handle #{handle} for #{args[:id]}"
      else
        puts "Identifier(s) exist for #{args[:id]}: #{object.identifier}"
      end
    end

    desc 'Ensures that the handle for the object is up to date. Supply an id.'
    task :update, [:id] => :environment do |_, args|
      object = find_or_warn(args[:id]) || next

      if object.identifier.empty?
        $stderr.puts "No handle is registered for the object: #{object.uri}"
        next
      else
        Tufts::HandleRegistrar.new.update!(handle: object.identifier.first,
                                           object: object)
      end
    end
  end
end
