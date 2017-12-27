module Tufts
  # Create and maintain the Collection objects required by the Contribute controller
  class ContributeCollections
    attr_reader :seed_data

    def initialize
      @seed_data = make_seed_data_hash
    end

    def make_seed_data_hash
      seed_hash = {}
      SEED_DATA.each do |c|
        id = convert_id(c[:identifier])
        seed_hash[id] = c
      end
      seed_hash
    end

    def self.create
      Tufts::ContributeCollections.new.create
    end

    # Convert a legacy Tufts identifier into a predictable and valid Fedora identifier
    # @param [String] id
    # @return [String]
    def convert_id(id)
      newid = id.downcase
      newid.slice!('tufts:')
      newid.tr!('.', '_')
    end

    def create
      @seed_data.keys.each do |collection_id|
        find_or_create_collection(collection_id)
      end
    end

    # Given a collection id, find or create the collection.
    # If the collection has been deleted, eradicate it so the id can be
    # re-used, and re-create the collection object.
    # @param [String] collection_id
    # @return [Collection]
    def find_or_create_collection(collection_id)
      Collection.find(collection_id)
    rescue ActiveFedora::ObjectNotFoundError
      create_collection(collection_id)
    rescue Ldp::Gone
      Collection.eradicate(collection_id)
      create_collection(collection_id)
    end

    # @param [String] collection_id
    # @return [Collection]
    def create_collection(collection_id)
      collection = Collection.new(id: collection_id)
      collection_hash = @seed_data[collection_id]
      collection.title = Array(collection_hash[:title])
      collection.identifier = Array(collection_hash[:identifier])
      collection.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      collection.save
      collection
    end

    # Convenience method for use by the contribute controller
    # @param [Class] work_type
    # @return [Collection]
    # @example
    #  Tufts::ContributeCollections.collection_for_work_type(FacultyScholarship)
    def self.collection_for_work_type(work_type)
      Tufts::ContributeCollections.new.collection_for_work_type(work_type)
    end

    # For a given work type, determine which Collection contributions should go into.
    # If that collection object doesn't exist for some reason, create it.
    # @param [Class] work_type
    # @return [Collection]
    def collection_for_work_type(work_type)
      collection_id = @seed_data.select { |_key, hash| hash[:work_types].include? work_type }.keys.first
      Collection.find(collection_id)
    rescue ActiveFedora::ObjectNotFoundError
      create_collection(collection_id)
    rescue Ldp::Gone
      Collection.eradicate(collection_id)
      create_collection(collection_id)
    end

    SEED_DATA = [
      {
        title: "Tufts Published Scholarship, 1987-2014",
        identifier: "tufts:UA069.001.DO.PB",
        work_types: [GenericDeposit, GenericTischDeposit, GisPoster, UndergradSummerScholar, FacultyScholarship]
      },
      {
        title: "Fletcher School Records, 1923 -- 2016",
        identifier: "tufts:UA069.001.DO.UA015",
        work_types: [CapstoneProject]
      },
      {
        title: "Cummings School of Veterinary Medicine records, 1969-2012",
        identifier: "tufts:UA069.001.DO.UA041",
        work_types: [CummingsThesis]
      },
      {
        title: "Undergraduate honors theses, 1929-2015",
        identifier: "tufts:UA069.001.DO.UA005",
        work_types: [HonorsThesis]
      },
      {
        title: "Public Health and Professional Degree Programs Records, 1990 -- 2011",
        identifier: "tufts:UA069.001.DO.UA187",
        work_types: [PublicHealth]
      },
      {
        title: "Department of Education records, 2007-02-01-2014",
        identifier: "tufts:UA069.001.DO.UA071",
        work_types: [QualifyingPaper]
      }
    ].freeze
  end
end
