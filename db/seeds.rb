# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Ingredient.destroy_all if Rails.env.development?
# Cocktail.destroy_all if Rails.env.development?

require 'json'
require 'open-uri'

url = 'https://raw.githubusercontent.com/maltyeva/iba-cocktails/master/recipes.json'
cocktail = JSON.parse(open(url).read)
ing_array = []
cocktail.each do |e|
  # p e['name']
  e['ingredients'].each do |i|
    ing_array.push(i['ingredient']) if i['ingredient'].nil? == false
  end
  Cocktail.create(name: e['name'])
end

ingredient_arr = ing_array.uniq
ingredient_arr.each do |i|
  Ingredient.create(name: i)
end
p "created no replicates ingredients"

cocktail.each do |e|
  c = Cocktail.find_by(name: e['name'])
  e['ingredients'].each do |d|
    if d['amount'].nil? == false && d['ingredient'].nil? == false
      Dose.create(description: d['amount'], cocktail_id: c.id, ingredient_id: Ingredient.find_by(name: d['ingredient']).id)
    end
  end
end

p "created doses"
