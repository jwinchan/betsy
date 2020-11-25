require "test_helper"

describe User do
  describe "validations" do
    before do
      @user = users(:ada)
    end
    it 'is valid when all fields are present' do
      expect(@user.valid?).must_equal true
    end

    it "is invalid when uid is missing" do
      @user.uid = nil
      expect(@user.valid?).must_equal false
    end

    it "is invalid when name is missing" do
      @user.name = nil
      expect(@user.valid?).must_equal false
    end

    it "is invalid when email is missing" do
      @user.email = nil
      expect(@user.valid?).must_equal false
    end
  end

  describe "relations" do
    describe "products" do
    end
    
    describe "orderitems" do
    end

    describe "categories" do
    end
  end

  describe "custom methods" do
    describe "total_revenue" do
      it "sums up subtotal of each orderitem from [pending, paid, completed] status" do
        # Arrange & Act
        user1 = users(:ada)
        # order items belong to user1
        orderitem1 = orderitems(:orderitem1) # pending
        orderitem2 = orderitems(:orderitem2) # paid
        orderitem5 = orderitems(:orderitem5) # completed
        orderitem6 = orderitems(:orderitem6) # pending
        orderitem7 = orderitems(:orderitem7) # paid
        orderitem8 = orderitems(:orderitem8) # completed

        # Act
        count = user1.total_revenue

        # Assert
        expect(user1.orderitems.count).must_equal 6

        target_amount = orderitem1.price + orderitem2.price + orderitem5.price + orderitem6.price + orderitem7.price + orderitem8.price
        expect(count).must_equal target_amount
      end

      it "will not add the subtotal from cancelled status" do
        # Arrange & Act
        user2 = users(:grace)
        # order items belong to user2
        orderitem3 = orderitems(:orderitem3) # pending
        orderitem4 = orderitems(:orderitem4) # cancelled

        # Act
        count = user2.total_revenue

        # Assert
        expect(user2.orderitems.count).must_equal 2

        target_amount = orderitem3.price 
        expect(count).must_equal target_amount
      end  
      
      it "will return 0 if no order item in the fulfillment list" do
        # Arrange & Act
        user3 = users(:color)

        # Act
        count = user3.total_revenue

        # Assert
        expect(user3.orderitems.count).must_equal 0
        expect(count).must_equal 0
      end  
    end

    describe "total_revenue_by_status" do
      it "sums up subtotal of each orderitem for pending status" do
        # Arrange & Act
        user1 = users(:ada)
        # order items under pending for user1
        orderitem1 = orderitems(:orderitem1) # pending
        orderitem6 = orderitems(:orderitem6) # pending

        # Act
        count = user1.total_revenue_by_status("pending")

        # Assert
        expect(user1.orderitems.where(order_status: "pending").count).must_equal 2
        total_revenue_pending = orderitem1.price + orderitem6.price
        expect(count).must_equal total_revenue_pending
      end 

      it "sums up subtotal of each orderitem for paid status" do
        # Arrange & Act
        user1 = users(:ada)
        # order items under pending for user1
        orderitem2 = orderitems(:orderitem2) # paid
        orderitem7 = orderitems(:orderitem7) # paid

        # Act
        count = user1.total_revenue_by_status("paid")

        # Assert
        expect(user1.orderitems.where(order_status: "paid").count).must_equal 2
        total_revenue_paid = orderitem2.price + orderitem7.price
        expect(count).must_equal total_revenue_paid
      end 

      it "sums up subtotal of each orderitem for completed status" do
        # Arrange & Act
        user1 = users(:ada)
        # order items under pending for user1
        orderitem5 = orderitems(:orderitem5) # completed
        orderitem8 = orderitems(:orderitem8) # completed

        # Act
        count = user1.total_revenue_by_status("completed")

        # Assert
        expect(user1.orderitems.where(order_status: "completed").count).must_equal 2
        total_revenue_completed = orderitem5.price + orderitem8.price
        expect(count).must_equal total_revenue_completed
      end 
      
      it "will return 0 if no order item in one of the status" do
        # Arrange & Act
        # user2 doesn't have order item under paid status
        user2 = users(:grace) 

        # Act
        count = user2.total_revenue_by_status("paid")

        # Assert
        expect(user2.orderitems.where(order_status: "paid").count).must_equal 0
        expect(count).must_equal 0
      end  
    end

    describe "total_orders" do
      it "sums up the number of order from [pending, paid, completed] status" do
        # Arrange & Act
        user1 = users(:ada)
        # order items belong to user1
        orderitem1 = orderitems(:orderitem1) # pending
        orderitem2 = orderitems(:orderitem2) # paid
        orderitem5 = orderitems(:orderitem5) # completed
        orderitem6 = orderitems(:orderitem6) # pending
        orderitem7 = orderitems(:orderitem7) # paid
        orderitem8 = orderitems(:orderitem8) # completed

        # Act
        count = user1.total_orders

        # Assert
        expect(count).must_equal user1.orderitems.count
      end

      it "will not add the number of order from cancelled status" do
        # Arrange & Act
        user2 = users(:grace)
        # order items belong to user2
        orderitem3 = orderitems(:orderitem3) # pending
        orderitem4 = orderitems(:orderitem4) # cancelled

        # Act
        count = user2.total_orders

        # Assert
        expect(user2.orderitems.count).must_equal 2
        expect(count).must_equal 1
        expect(user2.orderitems.where(order_status: "cancelled").count).must_equal 1
      end

      it "will return 0 if no order item in the fulfillment list" do
        # Arrange & Act
        user3 = users(:color)

        # Act
        count = user3.total_orders

        # Assert
        expect(user3.orderitems.count).must_equal 0
        expect(count).must_equal 0
      end
    end
    
    describe "total_orders_by_status" do
      it "sums up the number of order for pending status" do
        # Arrange & Act
        user1 = users(:ada)
        # order items under pending for user1
        orderitem1 = orderitems(:orderitem1) # pending
        orderitem6 = orderitems(:orderitem6) # pending

        # Act
        count = user1.total_orders_by_status("pending")

        # Assert
        user_pending_orderitem = user1.orderitems.where(order_status: "pending").count
        expect(count).must_equal user_pending_orderitem
      end 

      it "sums up the number of order for paid status" do
        # Arrange & Act
        user1 = users(:ada)
        # order items under pending for user1
        orderitem2 = orderitems(:orderitem2) # paid
        orderitem7 = orderitems(:orderitem7) # paid

        # Act
        count = user1.total_orders_by_status("paid")

        # Assert
        user_paid_orderitem = user1.orderitems.where(order_status: "paid").count
        expect(count).must_equal user_paid_orderitem
      end 

      it "sums up the number of order for completed status" do
        # Arrange & Act
        user1 = users(:ada)
        # order items under pending for user1
        orderitem5 = orderitems(:orderitem5) # completed
        orderitem8 = orderitems(:orderitem8) # completed

        # Act
        count = user1.total_orders_by_status("completed")

        # Assert
        user_completed_orderitem = user1.orderitems.where(order_status: "completed").count
        expect(count).must_equal user_completed_orderitem
      end 
      
      it "will return 0 if no order item in one of the status" do
        # Arrange & Act
        # user2 doesn't have order item under paid status
        user2 = users(:grace) 

        # Act
        count = user2.total_orders_by_status("paid")

        # Assert
        user_paid_orderitem = user2.orderitems.where(order_status: "paid").count
        expect(count).must_equal user_paid_orderitem
        expect(count).must_equal 0
      end  
    end

    describe "filter_by_status" do
      it "shows the orders by pending status" do
        # Arrange & Act
        user1 = users(:ada)
        # order items under pending for user1
        orderitem1 = orderitems(:orderitem1) # pending
        orderitem6 = orderitems(:orderitem6) # pending

        # Act
        count = user1.filter_by_status("pending")

        # Assert
        user_pending_orderitem = user1.orderitems.where(order_status: "pending")
        expect(count).must_equal user_pending_orderitem
        expect(count.count).must_equal 2
      end 

      it "shows the orders by paid status" do
        # Arrange & Act
        user1 = users(:ada)
        # order items under pending for user1
        orderitem2 = orderitems(:orderitem2) # paid
        orderitem7 = orderitems(:orderitem7) # paid

        # Act
        count = user1.filter_by_status("paid")

        # Assert
        user_paid_orderitem = user1.orderitems.where(order_status: "paid")
        expect(count).must_equal user_paid_orderitem
        expect(count.count).must_equal 2
      end 

      it "shows the orders by completed status" do
        # Arrange & Act
        user1 = users(:ada)
        # order items under pending for user1
        orderitem5 = orderitems(:orderitem5) # completed
        orderitem8 = orderitems(:orderitem8) # completed

        # Act
        count = user1.filter_by_status("completed")

        # Assert
        user_completed_orderitem = user1.orderitems.where(order_status: "completed")
        expect(count).must_equal user_completed_orderitem
        expect(count.count).must_equal 2
      end 
      
      it "will return 0 if no order item in one of the status" do
        # Arrange & Act
        # user2 doesn't have order item under paid status
        user2 = users(:grace) 

        # Act
        count = user2.filter_by_status("paid")

        # Assert
        user_paid_orderitem = user2.orderitems.where(order_status: "paid")
        expect(count).must_equal user_paid_orderitem
        expect(count.count).must_equal 0
      end  
    end

    describe "self.build_from_github" do
    end
  end
end
