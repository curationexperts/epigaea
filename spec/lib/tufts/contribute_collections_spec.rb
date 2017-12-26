require 'rails_helper'

RSpec.describe Tufts::ContributeCollections, :clean do
  let(:cc) { described_class.new }

  it "has a hash of all the collections to be made, with their ids and titles" do
    expect(cc.seed_data).to be_instance_of(Hash)
  end
  it "converts a legacy identifier into a predictable valid fedora id" do
    expect(cc.convert_id('tufts:UA069.001.DO.PB')).to eq("ua069_001_do_pb")
  end

  context "creating all the collections" do
    before do
      described_class.create
    end
    it "creates a collection object for each item in the seed array" do
      expect(Collection.count).to eq(6)
    end
    it "populates title and legacy identifier" do
      c = Collection.find("ua069_001_do_pb")
      expect(c.title.first).to eq("Tufts Published Scholarship, 1987-2014")
      expect(c.identifier.first).to eq("tufts:UA069.001.DO.PB")
    end
  end

  context "putting contributed works into collections" do
    before do
      described_class.create
    end
    it "finds the right collection for a given work type" do
      faculty_scholarship_collection = cc.collection_for_work_type(FacultyScholarship)
      expect(faculty_scholarship_collection).to be_instance_of(Collection)
      expect(faculty_scholarship_collection.id).to eq('ua069_001_do_pb')
    end
    it "recovers if one of the expected collections has been deleted" do
      Collection.find('ua069_001_do_pb').delete
      faculty_scholarship_collection = cc.collection_for_work_type(FacultyScholarship)
      expect(faculty_scholarship_collection).to be_instance_of(Collection)
      expect(faculty_scholarship_collection.id).to eq('ua069_001_do_pb')
    end
  end
end
