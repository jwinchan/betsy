require "test_helper"

describe OrdersController do
  describe "show" do
    it "redirects to order page for a logged-in user having sold products in an Order" do
      # Arrange
      valid_user = perform_login(users(:ada))
      valid_order = orders(:order1)
      
      # Act-Assert
      get order_path(valid_order)
      
      expect(session[:user_id]).must_equal valid_user.id
      expect(valid_order.products.where(user_id: valid_user.id)).
      wont_be_empty
      must_redirect_to order_path
    end

    it "redirects to root_path when a guest wants to see other users' order" do
      # Arrange
      valid_order = orders(:order1)
      
      # Act-Assert
      get order_path(valid_order)
      
      expect(session[:user_id]).must_be_nil
      expect(valid_order.products.where(user_id: session[:user_id])).
      must_be_empty
      must_redirect_to root_path
    end

    it "redirects to root_path when an user wants to see other users' order" do
      # Arrange
      invalid_user = perform_login(users(:color))
      valid_order = orders(:order1)
      
      # Act-Assert
      get order_path(valid_order)
      
      expect(session[:user_id]).must_equal invalid_user.id
      expect(valid_order.products.where(user_id: invalid_user.id)).
      must_be_empty
      must_redirect_to root_path
    end

    it "responds with 404 with an invalid order id" do
      # Arrange
      invalid_order_page = -1

      # Act
      get order_path(invalid_order_page)

      # Assert
      must_respond_with :not_found
    end
  end
end
