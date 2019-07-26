# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Dose.destroy_all if Rails.env.development?
Cocktail.destroy_all if Rails.env.development?
Ingredient.destroy_all if Rails.env.development?

require 'json'
require 'open-uri'

# url = 'https://raw.githubusercontent.com/maltyeva/iba-cocktails/master/recipes.json'
url = 'recipe.json'
cocktail = JSON.parse(open(url).read)
cocktails_image_url = "image.json"
cocktails_image_json = open(cocktails_image_url).read
cocktails_image = JSON.parse(cocktails_image_json)["cocktails"]
# p cocktails_image

ing_array = []
cocktail[0..29].each_with_index do |e, ind|
    e['ingredients'].each do |i|
      ing_array.push(i['ingredient']) if i['ingredient'].nil? == false
    end
    Cocktail.create(name: e['name'], img: cocktails_image[ind]["image"])
end

p "created cocktails"

ingredient_arr = ing_array.uniq
p ingredient_arr
ingredient_arr.each do |i|
  Ingredient.create(name: i)
end
p "created no replicates ingredients"

cocktail[0..29].each do |e|
  c = Cocktail.find_by(name: e['name'])
  # e['name'] is the name of the cocktail
  e['ingredients'].each do |d|
    if d['amount'].nil? == false && d['ingredient'].nil? == false
      Dose.create(description: d['amount'], cocktail_id: c.id, ingredient_id: Ingredient.find_by(name: d['ingredient']).id)
    end
  end
end

p "created doses"
