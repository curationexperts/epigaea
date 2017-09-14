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
require 'tufts/workflow_setup'
# Our database has just been reset, so you MUST destroy and
# re-create all AdminSets too
w = Tufts::WorkflowSetup.new
w.setup

# DepositType.create!(display_name: 'Initial Seed', deposit_view: 'generic_deposit', license_name: 'N/A')
importer = DepositTypeImporter.new('./config/deposit_type_seed.csv')
importer.import_from_csv
