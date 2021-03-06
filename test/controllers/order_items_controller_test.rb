require "test_helper"

describe OrderItemsController do
  describe "create" do
    let (:valid_order_item) {
      {
        order_id: session[:order_id],
        product_id: products(:yoga).id,
        quantity: 5
      }
    }

    let (:invalid_order_quantity) {
      {
        order_id: session[:order_id],
        product_id: products(:yoga).id,
        quantity: 200
      }
    } 
    it "can add an existing product with the quantity under product stock quantity to Orderitems table from Product page" do
      # Arrange
      get cart_path  
      id = products(:yoga).id

      # Act & Assert
      expect {
        post product_order_items_path(id), params: valid_order_item
      }.must_differ 'Orderitem.count', 1

      order_item = Orderitem.last.reload

      expect(order_item.order_id).must_equal session[:order_id]
      expect(order_item.product_id).must_equal id
      expect(order_item.quantity).must_equal 5
      expect(order_item.price).must_equal (5 * products(:yoga).price)
      expect(order_item.quantity).must_be :<=, products(:yoga).stock

      expect(order_item.order_status).must_equal "pending"
      expect(order_item.shipped).must_equal false
      expect(order_item.cancelled).must_equal false
      must_respond_with :redirect
    end

    it "cannot add an existing product with the quantity greater than product stock quantity from Product page" do
      # Arrange
      get cart_path  
      # confidence's stock quantity is 100
      id = products(:yoga).user_id

      # Act & Assert
      expect {
        post product_order_items_path(id), params: invalid_order_quantity
      }.wont_change 'Orderitem.count'

      expect(session[:order_id]).wont_be_nil
      order_item = Orderitem.find_by(order_id: session[:order_id], product_id: id)
      expect(order_item).must_be_nil
      must_respond_with :redirect
    end

    it "cannot add an non-existing product to Orderitems table from Product page" do
      # Arrange
      get cart_path  
 
      # Act & Assert
      expect {
        post product_order_items_path(-1)
      }.wont_change 'Orderitem.count'

      expect(session[:order_id]).wont_be_nil
      must_respond_with :redirect
    end

    it "can edit an existing product with the quantity under product stock quantity to Orderitems table from Product page" do
      # Arrange
      get cart_path  
      id = products(:yoga).id

      # Act
      # add a new item to Orderitems table
      expect {
        post product_order_items_path(id), params: valid_order_item
      }.must_differ 'Orderitem.count', 1

      # Assert
      # edit that item from Product page
      expect {
        post product_order_items_path(id), params: valid_order_item
      }.wont_change 'Orderitem.count'

      order_item = Orderitem.find_by(order_id: session[:order_id], product_id: id)

      expect(order_item.quantity).must_equal 10
      expect(order_item.price).must_equal (10 * products(:yoga).price)
      expect(order_item.quantity).must_be :<=, products(:yoga).stock

      expect(order_item.order_status).must_equal "pending"
      expect(order_item.shipped).must_equal false
      expect(order_item.cancelled).must_equal false
      must_respond_with :redirect
    end

    it "cannot edit an existing product with the quantity greater than product stock quantity from Product page" do
      # Arrange
      get cart_path  
      # confidence's stock quantity is 100
      id = products(:yoga).id

      # Act & Assert
      # add a new item to Orderitems table
      expect {
        post product_order_items_path(id), params: valid_order_item
      }.must_differ 'Orderitem.count', 1

      # Assert
      # edit that item from Product page
      expect {
        post product_order_items_path(id), params: invalid_order_quantity
      }.wont_change 'Orderitem.count'

      order_item = Orderitem.find_by(order_id: session[:order_id], product_id: id)

      expect(order_item.quantity).must_equal 5
      expect(order_item.price).must_equal (5 * products(:yoga).price)
      expect(order_item.quantity).must_be :<=, products(:yoga).stock
      must_respond_with :redirect
    end
  end

  describe "shipped" do
    it "can mark a paid order item as shipped when the logged-in user is also the product merchant" do
      # Arrange
      valid_user = perform_login(users(:ada))
      # user1 is product1's merchant
      valid_order_item = orderitems(:orderitem1) 
      valid_order_item.shipped = false
      valid_order_item.order_status = "paid"
      valid_order_item.save
      
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

    it "cannot unmark a shipped order item even the logged-in user is the product merchant" do
      # Arrange
      valid_user = perform_login(users(:ada))
      # user1 is product1's merchant
      shipped_order_item = orderitems(:orderitem1) 
      shipped_order_item.shipped = true
      shipped_order_item.order_status = "completed"
      shipped_order_item.save
      
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
      valid_user = perform_login(users(:ada))
      # user1 is product1's merchant
      invalid_order_item = orderitems(:orderitem1) 
      invalid_order_item.shipped = false
      invalid_order_item.order_status = "pending"
      invalid_order_item.save
      
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
      invalid_user = perform_login(users(:grace))
      # user1 is product1's merchant
      valid_order_item = orderitems(:orderitem1) 
      valid_order_item.shipped = false
      valid_order_item.order_status = "paid"
      valid_order_item.save
      
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
    it "can mark a paid order item as cancelled when the logged-in user is also the product merchant" do
      # Arrange
      valid_user = perform_login(users(:ada))
      # user1 is product1's merchant
      valid_order_item = orderitems(:orderitem1) 
      valid_order_item.cancelled = false
      valid_order_item.order_status = "paid"
      valid_order_item.save
      
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

    it "cannot unmark a cancelled order item even the logged-in user is the product merchant" do
      # Arrange
      valid_user = perform_login(users(:ada))
      # user1 is product1's merchant
      cancelled_order_item = orderitems(:orderitem1) 
      cancelled_order_item.cancelled = true
      cancelled_order_item.order_status = "cancelled"
      cancelled_order_item.save
      
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
      valid_user = perform_login(users(:ada))
      # user1 is product1's merchant
      invalid_order_item = orderitems(:orderitem1) 
      invalid_order_item.cancelled = false
      invalid_order_item.order_status = "pending"
      invalid_order_item.save
      
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
      invalid_user = perform_login(users(:grace))
      # user1 is product1's merchant
      valid_order_item = orderitems(:orderitem1) 
      valid_order_item.cancelled = false
      valid_order_item.order_status = "paid"
      valid_order_item.save
      
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

  describe "update" do
    let (:order_item_params) {
      {
          order_id: 1,
          quantity: 5
      }
    }
    it 'should find a valid order_item' do
      item = orderitems(:orderitem1)

      patch cart_update_path(item.id)

      exist = Orderitem.find_by(id: item.id)
      expect(exist).must_equal item
    end

    it 'should find valid product' do
      product = Product.create
      product.name = 'test_product'
      order_item = Orderitem.create

      order_item.product_id = product.id

      expect {
        patch cart_update(1)
      }

    end

    it 'should redirect if order_item is nil' do
      expect {
        patch cart_update_path(-1)
      }.wont_change "Orderitem.count"

      must_respond_with :redirect
      non_exist = Orderitem.find_by(id: -1)
      expect(non_exist).must_be_nil
    end

    it 'should save update to order item' do
      item = orderitems(:orderitem1)
      expect(item.quantity).must_equal 1

      patch cart_update_path(item.id), params: order_item_params

      must_respond_with :redirect
      expect(item.reload.quantity).must_equal 5
      must_respond_with :redirect
    end
  end

  describe "destroy" do
    it 'should redirect if order_item is nil' do
      expect {
        delete order_item_path(-1)
      }.wont_change "Orderitem.count"

      non_exist = Orderitem.find_by(id: -1)
      expect(non_exist).must_be_nil
      must_respond_with :redirect
    end

    it 'should destroy order item' do
      first_item = Orderitem.find_by(id: 1)

      expect(Orderitem.count).must_equal 8

      expect {
        delete order_item_path(first_item.id)
      }.must_change "Orderitem.count", 1

      must_respond_with :redirect
    end
  end
end
