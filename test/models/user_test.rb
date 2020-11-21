require "test_helper"

describe User do
  describe "validations" do
    it 'is valid when all fields are present' do
    end
  end

  describe "relaitons" do
    describe "products" do
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
  end
end
