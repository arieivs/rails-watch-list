# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'json'

puts 'Cleaning database...'
List.destroy_all
Movie.destroy_all

puts 'Creating movies...'
url = 'http://tmdb.lewagon.com/movie/top_rated'
movies_data = JSON.parse(URI.open(url).read)
movies_data['results'].slice(0...10).each do |movie|
  Movie.create(title: movie['title'], overview: movie['overview'], rating: movie['vote_average'], poster_url: "https://image.tmdb.org/t/p/w500#{movie['poster_path']}")
end
puts "#{Movie.count} movies created!"

puts 'Creating lists...'
lists_names = ['To watch', 'Classics', 'Comedy', 'Thrillers', 'Children']
lists_names.each do |list_name|
  List.create(name: list_name)
end
puts "#{List.count} lists created!"

puts 'Creating bookmarks...'
i = 0
List.all.each do |list|
  2.times do
    Bookmark.create(list: list, movie: Movie.all[i], comment: Faker::Movie.quote)
    i += 1
  end
end
puts "#{Bookmark.count} bookmarks created!"

puts 'Done :)'
