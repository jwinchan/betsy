class Orderitem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  has_one :user, through: :product

  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }




end

