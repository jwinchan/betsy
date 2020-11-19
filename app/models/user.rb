class User < ApplicationRecord
  has_many :products
  has_many :orderitems, through: :products
  has_many :categories, through: :products

  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash[:uid]
    user.provider = "github"
    user.name = auth_hash["info"]["name"]
    user.email = auth_hash["info"]["email"]

    return user
  end

end
