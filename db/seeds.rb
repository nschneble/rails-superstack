# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# seeds a user and admin
user = User.find_or_create_by!(
  email: "user@superstack.dev",
  role: :user
)

admin = User.find_or_create_by!(
  email: "admin@superstack.dev",
  role: :admin
)

# seeds a few MacGuffins
MacGuffin.find_or_create_by!(
  name: "Unobtainium",
  description: "An ideal material that's impractically difficult or impossible to obtain.",
  visibility: :open,
  user: user
)

MacGuffin.find_or_create_by!(
  name: "Letters of Transit",
  description: "What you need to get out of Casablanca.",
  visibility: :user,
  user: user
)

MacGuffin.find_or_create_by!(
  name: "The Infinity Stones",
  description: "How else will you reshape the universe?",
  visibility: :admin,
  user: admin
)
