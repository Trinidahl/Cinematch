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

puts 'creating new chats...'
Chat.create!(title: 'test chat 1', status: 'status chat 1', user_id: User.first.id)
Chat.create!(title: 'test chat 2', status: 'status chat 2', user_id: User.last.id)

puts 'creating new movies...'
Movie.create!([
  {
    title: "Inception",
    year: 2010,
    director: "Christopher Nolan",
    genre: "Science-Fiction",
    country: "USA",
    description: "Un voleur qui s'infiltre dans les rêves pour voler des secrets doit accomplir l'impossible : implanter une idée.",
    rank: 1,
    url: "https://www.imdb.com/title/tt1375666/",
    system_prompt: "Film sur la manipulation des rêves et la perception de la réalité."
  },
  {
    title: "Parasite",
    year: 2019,
    director: "Bong Joon-ho",
    genre: "Thriller",
    country: "Corée du Sud",
    description: "Une famille pauvre s'infiltre peu à peu dans la vie d'une famille riche, jusqu'à ce que tout déraille.",
    rank: 2,
    url: "https://www.imdb.com/title/tt6751668/",
    system_prompt: "Film sur la lutte des classes et la satire sociale."
  },
  {
    title: "The Godfather",
    year: 1972,
    director: "Francis Ford Coppola",
    genre: "Crime",
    country: "USA",
    description: "La saga d'une puissante famille mafieuse et de son héritier réticent.",
    rank: 3,
    url: "https://www.imdb.com/title/tt0068646/",
    system_prompt: "Film sur le pouvoir, la loyauté et la corruption."
  },
  {
    title: "Amélie",
    year: 2001,
    director: "Jean-Pierre Jeunet",
    genre: "Romance",
    country: "France",
    description: "Une jeune femme à l’imagination débordante décide de changer la vie des gens qui l’entourent.",
    rank: 4,
    url: "https://www.imdb.com/title/tt0211915/",
    system_prompt: "Film poétique sur la bonté et la découverte de soi."
  },
  {
    title: "Spirited Away",
    year: 2001,
    director: "Hayao Miyazaki",
    genre: "Animation",
    country: "Japon",
    description: "Une fillette se retrouve dans un monde magique où les esprits dominent et doit sauver ses parents transformés en porcs.",
    rank: 5,
    url: "https://www.imdb.com/title/tt0245429/",
    system_prompt: "Film d'animation fantastique sur la croissance et le courage."
  },
  {
    title: "Pulp Fiction",
    year: 1994,
    director: "Quentin Tarantino",
    genre: "Crime",
    country: "USA",
    description: "Des histoires entrecroisées de criminels à Los Angeles, mêlant humour noir et violence stylisée.",
    rank: 6,
    url: "https://www.imdb.com/title/tt0110912/",
    system_prompt: "Film sur la moralité et le destin dans un monde chaotique."
  },
  {
    title: "The Dark Knight",
    year: 2008,
    director: "Christopher Nolan",
    genre: "Action",
    country: "USA",
    description: "Batman affronte le Joker, un criminel anarchique qui cherche à semer le chaos à Gotham.",
    rank: 7,
    url: "https://www.imdb.com/title/tt0468569/",
    system_prompt: "Film sur la dualité entre justice et chaos."
  },
  {
    title: "La vita è bella",
    year: 1997,
    director: "Roberto Benigni",
    genre: "Drame",
    country: "Italie",
    description: "Un père utilise l’humour pour protéger son fils de l’horreur des camps de concentration.",
    rank: 8,
    url: "https://www.imdb.com/title/tt0118799/",
    system_prompt: "Film émouvant sur l'amour paternel et la résilience."
  },
  {
    title: "Interstellar",
    year: 2014,
    director: "Christopher Nolan",
    genre: "Science-Fiction",
    country: "USA",
    description: "Une équipe d’astronautes voyage à travers un trou de ver pour sauver l’humanité.",
    rank: 9,
    url: "https://www.imdb.com/title/tt0816692/",
    system_prompt: "Film sur le temps, l’amour et la survie de l’espèce humaine."
  },
  {
    title: "City of God",
    year: 2002,
    director: "Fernando Meirelles",
    genre: "Drame",
    country: "Brésil",
    description: "L’histoire de jeunes dans les favelas de Rio, entre violence et espoir.",
    rank: 10,
    url: "https://www.imdb.com/title/tt0317248/",
    system_prompt: "Film sur la violence urbaine et la destinée dans les quartiers défavorisés."
  }
])

puts 'creating new recommendations...'
Recommendation.create!(chat_id: Chat.first.id, movie_id: Movie.first.id, unchosen: false)
Recommendation.create!(chat_id: Chat.first.id, movie_id: Movie.last.id, unchosen: false)
