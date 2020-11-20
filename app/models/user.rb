class User < ApplicationRecord
  has_many :products
  has_many :orderitems, through: :products
  has_many :categories, through: :products


  def total_revenue
    return total_revenue = self.orderitems.where(order_status: ["pending", "paid", "completed"]).sum { |order_item| order_item.price }
  end

  
  def total_revenue_by_status(status)
    total_revenue_status = 0
    self.orderitems.each do |order_item|
      if order_item.order_status == status
        total_revenue_status += order_item.price
      end
    end  
    return total_revenue_status
  end

  # Does this mean how many Orders? Or how many quantity of total order_items?
  def total_orders
    return self.orderitems.where(order_status: ["pending", "paid", "completed"]).count
  end

  def total_orders_by_status(status)
    total_orders_status = 0
    self.orderitems.each do |order_item|
      if order_item.order_status == status
        total_orders_status += 1
      end
    end  
    return total_orders_status
  end

  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash[:uid]
    user.provider = "github"
    user.name = auth_hash["info"]["nickname"]
    user.email = auth_hash["info"]["email"]

    return user
  end

end
