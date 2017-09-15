require 'import_export/deposit_type_importer'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts
puts "== Setting mira publication workflow =="
puts
# Ensure default admin set and its associated permission template exist,
# and load the mira_publication_workflow
require 'tufts/workflow_setup'
Tufts::WorkflowSetup.setup

# DepositType.create!(display_name: 'Initial Seed', deposit_view: 'generic_deposit', license_name: 'N/A')
importer = DepositTypeImporter.new('./config/deposit_type_seed.csv')
importer.import_from_csv
