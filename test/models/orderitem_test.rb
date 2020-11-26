require "test_helper"

describe Orderitem do
  describe "relations" do
    describe "product" do
      it "can set the product using a Product" do
        # Arrange
        orderitem1 = orderitems(:orderitem1)
        product1 = products(:confidence)

        # Act & Assert
        expect(orderitem1.product).must_equal product1
      end
  
      it "can set the product using a product_id" do
        # Arrange
        orderitem1 = orderitems(:orderitem1)
        product1 = products(:confidence)

        # Act & Assert
        expect(orderitem1.product_id).must_equal product1.id
      end
    end

    describe "order" do
      it "can set the order using a Order" do
        # Arrange
        orderitem1 = orderitems(:orderitem1)
        order1 = orders(:order1)

        # Act & Assert
        expect(orderitem1.order).must_equal order1
      end
  
      it "can set the order using a product_id" do
        # Arrange
        orderitem1 = orderitems(:orderitem1)
        order1 = orders(:order1)

        # Act & Assert
        expect(orderitem1.order_id).must_equal order1.id
      end
    end

    describe "user" do
      it "can set the user using a User" do
        # Arrange
        orderitem1 = orderitems(:orderitem1)
        user1 = users(:ada)

        # Act & Assert
        expect(orderitem1.user).must_equal user1
      end
    end
  end

  describe "validates" do
    it 'is valid when all fields are present' do
      # Act
      orderitem1 = orderitems(:orderitem1)
      
      # Arrange
      result = orderitem1.valid?

      # Assert
      expect(result).must_equal true
    end

    it 'is invalid without a quantity' do
      # Arrange
      orderitem1 = orderitems(:orderitem1)
      orderitem1.quantity = nil
    
      # Act
      result = orderitem1.valid?
    
      # Assert
      expect(result).must_equal false
      expect(orderitem1.errors.messages).must_include :quantity
      expect(orderitem1.errors.messages[:quantity].include?("can't be blank")).must_equal true
    end

    it 'is invalid with a non-integer quantity' do
      # Arrange
      orderitem1 = orderitems(:orderitem1)
      orderitem1.quantity = "test"
    
      # Act
      result = orderitem1.valid?
    
      # Assert
      expect(result).must_equal false
      expect(orderitem1.errors.messages).must_include :quantity
      expect(orderitem1.errors.messages[:quantity].include?("is not a number")).must_equal true
    end

    it 'is invalid when quantity <= 0' do
      # Arrange
      orderitem1 = orderitems(:orderitem1)
      orderitem1.quantity = 0
    
      # Act
      result = orderitem1.valid?
    
      # Assert
      expect(result).must_equal false
      expect(orderitem1.errors.messages).must_include :quantity
      expect(orderitem1.errors.messages[:quantity].include?("must be greater than 0")).must_equal true
    end
  end
end
