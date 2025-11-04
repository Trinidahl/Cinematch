# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts 'Cleaning User table...'
User.destroy_all

puts 'Cleaning Chat table...'
Chat.destroy_all

puts 'cleaning Movie table...'
Movie.destroy_all

puts 'cleaning Recommendation table...'
Recommendation.destroy_all

puts 'creating new users...'
User.create!(email: 'test-1@gmail.com', password: '1234567', name: 'Roland')
User.create!(email: 'test-2@gmail.com', password: '4567891', name: 'Georgette')
