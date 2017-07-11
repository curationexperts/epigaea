require 'spec_helper'
require 'tufts/draftable'

RSpec.describe Tufts::Draftable do
  subject(:model)   { model_class.new }
  let(:model_class) { Class.new }

  it_behaves_like 'a draftable model'
end
