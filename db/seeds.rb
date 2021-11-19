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
lists_data = [
  ['To watch', 'https://images.unsplash.com/photo-1559780528-19fc03b3a725?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80'],
  ['Classics', 'https://images.unsplash.com/photo-1532751203793-812308a10d8e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=346&q=80'],
  ['Comedy', 'https://images.unsplash.com/photo-1509512693283-8178ed23e04c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=437&q=80'],
  ['Thrillers', 'https://images.unsplash.com/photo-1523712900580-a5cc2e0112ed?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80'],
  ['Children', 'https://images.unsplash.com/photo-1606092195730-5d7b9af1efc5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80']]
lists_data.each do |list_data|
  list = List.new(name: list_data[0])
  file = URI.open(list_data[1])
  list.photo.attach(io: file, filename: 'cover.png', content_type: 'image/png')
  list.save
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
