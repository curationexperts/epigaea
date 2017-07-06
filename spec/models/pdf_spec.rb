# Generated via
#  `rails generate hyrax:work Pdf`
require 'rails_helper'

RSpec.describe Pdf do
  let(:pdf) { FactoryGirl.build(:pdf) }
  context 'displays_in' do
    it 'has Tufts displays_in metadata' do
      pdf.displays_in = ['nowhere', 'trove']
      expect(pdf.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#displays_in/)
    end
  end
end
