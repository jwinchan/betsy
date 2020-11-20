class Orderitem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  has_one :user, through: :product
end
