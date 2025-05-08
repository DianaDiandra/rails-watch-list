# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'open-uri'
require 'json'

puts "Cleaning up database..."
Movie.destroy_all
puts "Database cleaned"

puts "Fetching movies from TMDB..."
url = 'https://tmdb.lewagon.com/movie/top_rated'
response = URI.open(url).read
movies = JSON.parse(response)['results']

puts "Creating movies..."
movies.each do |movie|
  poster_path = movie['poster_path']
  image_url = "https://image.tmdb.org/t/p/w500#{poster_path}"

  Movie.create!(
    title: movie['title'],
    overview: movie['overview'],
    poster_url: image_url,
    rating: movie['vote_average']
  )
end

puts "Created #{Movie.count} movies!"

puts "Creating lists..."
List.create!(name: "Action Favorites")
List.create!(name: "Rom-Coms")
List.create!(name: "Watch Later")
puts "Created #{List.count} lists!"
