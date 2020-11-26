require "test_helper"

describe Review do
  describe "relation" do
    describe "products" do
      it "can set the product using a Product" do
        # Arrange
        review1 = reviews(:review1) # for product1
        product1 = products(:confidence)

        # Act & Assert
        expect(review1.product).must_equal product1
      end

      it "can set the product using a product_id" do
        # Arrange
        review1 = reviews(:review1) # for product1
        product1 = products(:confidence)

        # Act & Assert
        expect(review1.product_id).must_equal product1.id
      end
    end
  end  

  describe "validates" do
    it 'is valid when all fields are present' do
      # Arrange
      review1 = reviews(:review1)
      # Act
      result = review1.valid?

      # Assert
      expect(result).must_equal true
    end

    it "is invalid when rating is missing" do
      # Arrange
      review1 = reviews(:review1)
      review1.rating = nil

      # Act
      result = review1.valid?

      # Assert
      expect(result).must_equal false
    end

    it "is invalid when rating is not in (1..5)" do
      # Arrange
      review1 = reviews(:review1)
      review1.rating = 6

      # Act
      result = review1.valid?

      # Assert
      expect(result).must_equal false
    end
  end
end
