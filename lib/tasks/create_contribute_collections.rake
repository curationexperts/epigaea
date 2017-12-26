require 'rake'

namespace :tufts do
  desc "Create contribute collections"
  task create_contribute_collections: :environment do
    Tufts::ContributeCollections.create
  end
end
