require "faker"
require "date"
require "csv"

# we already provide a filled out works_seeds.csv file, but feel free to
# run this script in order to replace it and generate a new one
# run using the command:
# $ ruby db/generate_seeds.rb
# if satisfied with this new works_seeds.csv file, recreate the db with:
# $ rails db:reset
# doesn't currently check for if titles are unique against each other

CSV.open("db/seed_data/products_seeds.csv", "w", :write_headers => true,
         :headers => ["name", "stock", "price", "description", "user_id", "photo_url", "retired"]) do |csv|
  25.times do
    name = Faker::Name.name
    stock = rand(0..500)
    price =  rand(100..10000)
    description = Faker::Lorem.sentence
    user_id = rand(1..10)
    photo_url = Faker::Avatar.image
    retired = %w(true false).sample

    csv << [name, stock, price, description, user_id, photo_url, retired]
  end
end

CSV.open("db/seed_data/users_seeds.csv", "w", :write_headers => true,
         :headers => ["name", "description", "uid", "provider", "email"]) do |csv|
  10.times do
    name = Faker::Name.name
    description = Faker::Lorem.sentence
    uid = "#{rand(10000000..99999999)}"
    provider = "github"
    email = Faker::Internet.email

    csv << [name, description, uid, provider, email]
  end
end

