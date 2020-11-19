class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception
  before_action :order_cart 

  def order_cart
    cart = Order.find_by(id: session[:order_id])
    if cart
      order_cart = cart
    end
    order_cart = Order.create
    session[:order_id] = order_cart.id
  end
end
