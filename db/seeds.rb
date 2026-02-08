# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding started…" unless Rails.env.test?
start = Time.current

paths = [
  "db/seeds/shared/**/*.rb",
  "db/seeds/#{Rails.env}/**/*.rb"
]

paths.each do |pattern|
  Dir[Rails.root.join(pattern)].sort.each do |seed|
    relative_path = Pathname.new(seed).relative_path_from(Rails.root)
    puts "  ✓ Loading #{relative_path}" unless Rails.env.test?
    load seed
  rescue => exception
    puts "  ✗ Error loading #{relative_path}" unless Rails.env.test?
    raise exception
  end
end

puts "Seeding complete in #{(Time.current - start).round(2)}s" unless Rails.env.test?
