require "test_helper"

describe OrderItemsController do
  describe "shipped" do
    it "can mark an order item as shipped when the logged-in user is also the product merchant" do
      # Arrange
      valid_user = users(:ada)
      # user1 is product1's merchant
      valid_order_item = orderitems(:orderitem1) 
      valid_order_item.shipped = false
      valid_order_item.order_status = "paid"
      valid_order_item.save
      
      # Create session[:user_id]
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(valid_user))
      get omniauth_callback_path(:github)
      
      # Act-Assert
      expect {
        patch shipped_order_item_path(valid_order_item)
      }.wont_change 'Orderitem.count'

      expect(session[:user_id]).must_equal valid_user.id

      product_merchant = Product.find_by(id: valid_order_item.product_id)
      expect(product_merchant.user_id).must_equal valid_user.id

      valid_order_item.reload
      expect(valid_order_item.shipped).must_equal true
      expect(valid_order_item.order_status).must_equal "completed"
      must_respond_with :redirect   
    end

    it "cannot unmark a shipped order item when the logged-in user is also the product merchant" do
      # Arrange
      valid_user = users(:ada)
      # user1 is product1's merchant
      shipped_order_item = orderitems(:orderitem1) 
      shipped_order_item.shipped = true
      shipped_order_item.order_status = "completed"
      shipped_order_item.save
      
      # Create session[:user_id]
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(valid_user))
      get omniauth_callback_path(:github)
      
      # Act-Assert
      expect {
        patch shipped_order_item_path(shipped_order_item)
      }.wont_change 'Orderitem.count'

      expect(session[:user_id]).must_equal valid_user.id

      product_merchant = Product.find_by(id: shipped_order_item.product_id)
      expect(product_merchant.user_id).must_equal valid_user.id

      shipped_order_item.reload
      expect(shipped_order_item.shipped).must_equal true
      expect(shipped_order_item.order_status).must_equal "completed"
      must_respond_with :redirect    
    end

    it "cannot mark an order item as shipped when the order status is not paid" do
      # Arrange
      valid_user = users(:ada)
      # user1 is product1's merchant
      invalid_order_item = orderitems(:orderitem1) 
      invalid_order_item.shipped = false
      invalid_order_item.order_status = "pending"
      invalid_order_item.save
      
      # Create session[:user_id]
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(valid_user))
      get omniauth_callback_path(:github)
      
      # Act-Assert
      expect {
        patch shipped_order_item_path(invalid_order_item)
      }.wont_change 'Orderitem.count'

      expect(session[:user_id]).must_equal valid_user.id

      product_merchant = Product.find_by(id: invalid_order_item.product_id)
      expect(product_merchant.user_id).must_equal valid_user.id

      invalid_order_item.reload
      expect(invalid_order_item.shipped).must_equal false
      expect(invalid_order_item.order_status).must_equal "pending"
      must_respond_with :redirect  
    end

    it "cannot mark an order item as shipped without user login" do
      # Arrange
      # user1 is product1's merchant
      valid_order_item = orderitems(:orderitem1) 
      valid_order_item.shipped = false
      valid_order_item.order_status = "paid"
      valid_order_item.save

      # Act-Assert
      expect {
        patch shipped_order_item_path(valid_order_item)
      }.wont_change 'Orderitem.count'

      valid_order_item.reload
      expect(session[:user_id]).must_be_nil
      expect(valid_order_item.shipped).must_equal false
      expect(valid_order_item.order_status).must_equal "paid"
      must_redirect_to root_path 
    end

    it "cannot mark an order item as shipped when the user is not the owner" do
      # Arrange
      invalid_user = users(:grace)
      # user1 is product1's merchant
      valid_order_item = orderitems(:orderitem1) 
      valid_order_item.shipped = false
      valid_order_item.order_status = "paid"
      valid_order_item.save
      
      # Create session[:user_id]
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(invalid_user))
      get omniauth_callback_path(:github)
      
      # Act-Assert
      expect {
        patch shipped_order_item_path(valid_order_item)
      }.wont_change 'Orderitem.count'

      expect(session[:user_id]).must_equal invalid_user.id

      product_merchant = Product.find_by(id: valid_order_item.product_id)
      expect(product_merchant.user_id).wont_equal invalid_user.id

      valid_order_item.reload
      expect(valid_order_item.shipped).must_equal false
      expect(valid_order_item.order_status).must_equal "paid"
      must_respond_with :redirect  
    end

    it "cannot mark an order item as shipped if it's invalid and redirect to 404" do
      expect {
        patch shipped_order_item_path(-1)
      }.wont_change 'Orderitem.count'

      must_respond_with :not_found
    end
  end
  
  describe "cancelled" do
    it "can mark an order item as cancelled when the logged-in user is also the product merchant" do
      # Arrange
      valid_user = users(:ada)
      # user1 is product1's merchant
      valid_order_item = orderitems(:orderitem1) 
      valid_order_item.cancelled = false
      valid_order_item.order_status = "paid"
      valid_order_item.save
      
      # Create session[:user_id]
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(valid_user))
      get omniauth_callback_path(:github)
      
      # Act-Assert
      expect {
        patch cancelled_order_item_path(valid_order_item)
      }.wont_change 'Orderitem.count'

      expect(session[:user_id]).must_equal valid_user.id

      product_merchant = Product.find_by(id: valid_order_item.product_id)
      expect(product_merchant.user_id).must_equal valid_user.id

      valid_order_item.reload
      expect(valid_order_item.cancelled).must_equal true
      expect(valid_order_item.order_status).must_equal "cancelled"
      must_respond_with :redirect   
    end

    it "cannot unmark a cancelled order item when the logged-in user is also the product merchant" do
      # Arrange
      valid_user = users(:ada)
      # user1 is product1's merchant
      cancelled_order_item = orderitems(:orderitem1) 
      cancelled_order_item.cancelled = true
      cancelled_order_item.order_status = "cancelled"
      cancelled_order_item.save
      
      # Create session[:user_id]
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(valid_user))
      get omniauth_callback_path(:github)
      
      # Act-Assert
      expect {
        patch cancelled_order_item_path(cancelled_order_item)
      }.wont_change 'Orderitem.count'

      expect(session[:user_id]).must_equal valid_user.id

      product_merchant = Product.find_by(id: cancelled_order_item.product_id)
      expect(product_merchant.user_id).must_equal valid_user.id

      cancelled_order_item.reload
      expect(cancelled_order_item.cancelled).must_equal true
      expect(cancelled_order_item.order_status).must_equal "cancelled"
      must_respond_with :redirect    
    end

    it "cannot mark an order item as cancelled when the order status is not paid" do
      # Arrange
      valid_user = users(:ada)
      # user1 is product1's merchant
      invalid_order_item = orderitems(:orderitem1) 
      invalid_order_item.cancelled = false
      invalid_order_item.order_status = "pending"
      invalid_order_item.save
      
      # Create session[:user_id]
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(valid_user))
      get omniauth_callback_path(:github)
      
      # Act-Assert
      expect {
        patch cancelled_order_item_path(invalid_order_item)
      }.wont_change 'Orderitem.count'

      expect(session[:user_id]).must_equal valid_user.id

      product_merchant = Product.find_by(id: invalid_order_item.product_id)
      expect(product_merchant.user_id).must_equal valid_user.id

      invalid_order_item.reload
      expect(invalid_order_item.cancelled).must_equal false
      expect(invalid_order_item.order_status).must_equal "pending"
      must_respond_with :redirect  
    end

    it "cannot mark an order item as cancelled without user login" do
      # Arrange
      # user1 is product1's merchant
      valid_order_item = orderitems(:orderitem1) 
      valid_order_item.cancelled = false
      valid_order_item.order_status = "paid"
      valid_order_item.save

      # Act-Assert
      expect {
        patch cancelled_order_item_path(valid_order_item)
      }.wont_change 'Orderitem.count'

      valid_order_item.reload
      expect(session[:user_id]).must_be_nil
      expect(valid_order_item.cancelled).must_equal false
      expect(valid_order_item.order_status).must_equal "paid"
      must_redirect_to root_path 
    end

    it "cannot mark an order item as cancelled when the user is not the owner" do
      # Arrange
      invalid_user = users(:grace)
      # user1 is product1's merchant
      valid_order_item = orderitems(:orderitem1) 
      valid_order_item.cancelled = false
      valid_order_item.order_status = "paid"
      valid_order_item.save
      
      # Create session[:user_id]
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(invalid_user))
      get omniauth_callback_path(:github)
      
      # Act-Assert
      expect {
        patch cancelled_order_item_path(valid_order_item)
      }.wont_change 'Orderitem.count'

      expect(session[:user_id]).must_equal invalid_user.id

      product_merchant = Product.find_by(id: valid_order_item.product_id)
      expect(product_merchant.user_id).wont_equal invalid_user.id

      valid_order_item.reload
      expect(valid_order_item.cancelled).must_equal false
      expect(valid_order_item.order_status).must_equal "paid"
      must_respond_with :redirect  
    end

    it "cannot mark an order item as cancelled if it's invalid and redirect to 404" do
      expect {
        patch cancelled_order_item_path(-1)
      }.wont_change 'Orderitem.count'

      must_respond_with :not_found
    end
  end  
end
