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
      must_respond_with :success
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

  describe "cart" do
    #most testing for cart operation falls under orderitems controller
    it "responds with success when getting the cart page for guest" do
      get cart_path

      must_respond_with :success
    end

    it "responds with success when getting the cart page for logged-in user" do
      perform_login

      get cart_path

      must_respond_with :success
    end

    describe "order_cart" do
      it "creates an order if there's currently no cart in session" do

        expect {
          get cart_path
        }.must_change "Order.count", 1
      end

      it "does not create a new order if there's a cart in session" do
        get cart_path

        expect {
          get cart_path
        }.wont_differ "Order.count"
      end
    end
  end


end
