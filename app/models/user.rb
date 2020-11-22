class User < ApplicationRecord
  has_many :products
  has_many :orderitems, through: :products
  has_many :categories, through: :products

  validates :uid, uniqueness: {scope: :provider}


  def total_revenue
    return total_revenue = self.orderitems.where(order_status: ["pending", "paid", "completed"]).sum { |order_item| order_item.price }
  end

  
  def total_revenue_by_status(status)
    return total_revenue_status = self.orderitems.where(order_status: status).sum { |order_item| order_item.price }
  end

  # Does this mean how many Orders? Or how many quantity of total order_items?
  def total_orders
    return self.orderitems.where(order_status: ["pending", "paid", "completed"]).count
  end

  def total_orders_by_status(status)
    return self.orderitems.where(order_status: status).count
  end

  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash["uid"]
    user.provider = auth_hash["provider"]
    user.name = auth_hash["info"]["nickname"]
    user.email = auth_hash["info"]["email"]

    return user
  end

end
