require "test_helper"

describe User do
  describe "validations" do
    it 'is valid when all fields are present' do
      skip
    end
  end

  describe "relaitons" do
    describe "products" do
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
  end
end
