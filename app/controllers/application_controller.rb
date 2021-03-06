class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception
  before_action :order_cart
  before_action :find_user

  def order_cart
    @cart = Order.find_by(id: session[:order_id])
    if @cart.nil?
      @cart = Order.create
      # session[:order_id] = @cart.id
    end
    session[:order_id] = @cart.id
  end

  def render_404
    return render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  def clear_session(*args)
    args.each do |session_key|
      session[session_key] = nil
    end
  end

  private

  def find_user
    if session[:user_id]
      @login_user = User.find_by(id: session[:user_id])
    end
  end

end
