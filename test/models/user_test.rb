require "test_helper"

describe User do
  describe "validations" do
    it 'is valid when all fields are present' do
<<<<<<< HEAD
      skip
=======
>>>>>>> 14e87155e2dda42f394d05abdbf629e3b91c199c
    end
  end

  describe "relaitons" do
    describe "products" do
<<<<<<< HEAD
    end
    
    describe "orderitems" do
    end

    describe "categories" do
    end
  end

  describe "custom methods" do
    describe "total_revenue" do
      it "sums up subtotal of each orderitem from specific status" do
        # Arrange & Act
        user = users(:ada)
        orderitem1 = orderitems(:orderitem1) # pending
        orderitem2 = orderitems(:orderitem2) # paid

        # Act
        count = user.total_revenue

        # Assert
        expect(orderitem1.user.id).must_equal user.id
        target_amount = orderitem1.price + orderitem2.price
        expect(count).must_equal target_amount
      end

      it "will not add the subtotal from cancelled status" do
        # Arrange & Act
        user = users(:ada)
        orderitem1 = orderitems(:orderitem1) # pending
        orderitem2 = orderitems(:orderitem2) # paid

        # Act
        count = user.total_revenue

        # Assert
        target_amount = orderitem1.price + orderitem2.price
        expect(count).must_equal target_amount
      end      
    end

    describe "total_revenue_by_status" do
    end

    describe "total_orders" do
    end

    describe "total_orders_by_status" do
    end

    describe "self.build_from_github" do
    end
=======
      it "can set the product using a Product" do
        # Arrange & Act
        user1 = users(:ada)
        product1 = products(:confidence)

        # Assert
        connect = user1.products.find_by(id: product1.id)
        expect(connect).must_equal product1
      end

      it "can have many products" do
        # Arrange & Act
        user1 = users(:ada)

        # Assert
        expect(user1.products.count).must_equal 2
      end
    end
    
    describe "orderitems" do
    end

    describe "categories" do
    end
  end

  describe "custom methods" do
>>>>>>> 14e87155e2dda42f394d05abdbf629e3b91c199c
  end
end
