require "test_helper"

describe ReviewsController do
  let (:valid_review) {
    {
        review: {
            rating: 5
        }
    }
  }

  let (:invalid_review) {
    {
        review: {
            rating: -1
        }
    }
  }

  describe "new" do
    it "responds with success when review is created" do
      # Arrange
      product = products(:confidence)

      # Act
      get new_product_review_path(product)

      # Assert
      must_respond_with :success
    end

    it "responds with redirect when reviewer is not logged-in merchant" do
      # Arrange
      invalid_reviewer = perform_login(users(:ada))
      product = products(:confidence) # merchant is Ada

      # Act
      get new_product_review_path(product)

      # Assert
      must_respond_with :redirect
    end

    it "responds with redirect when review is not created" do
      # Arrange
      invalid_product = -1

      # Act
      get new_product_review_path(invalid_product)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "create" do
    it "can add review to an existing product" do
      # Arrange
      product = products(:confidence) 

      # Act & Assert
      expect {
        post product_reviews_path(product_id: product), params: valid_review
      }.must_differ 'Review.count', 1

      review = Review.last.reload
      expect(review.product_id).must_equal product.id
      expect(review.rating).must_equal 5
    end

    it "cannot add review to non-existing product" do
      # Arrange
      invalid_product = -1

      # Act & Assert
      expect {
        post product_reviews_path(-1), params: valid_review
      }.wont_change 'Review.count'
       
      must_respond_with :redirect
    end

    it "cannot add review to an existing product when reviewer is not logged-in merchant" do
      # Arrange
      invalid_reviewer = perform_login(users(:ada))
      product = products(:confidence)  # merchant is Ada

      # Act & Assert
      expect {
        post product_reviews_path(product_id: product), params: valid_review
      }.wont_change 'Review.count'

      must_respond_with :redirect
    end

    it "cannot add review an existing product with invalid rating" do
      # Arrange
      product = products(:confidence)

      # Act & Assert
      expect {
        post product_reviews_path(-1), params: invalid_review
      }.wont_change 'Review.count'
       
      must_respond_with :redirect
    end
  end

  describe "edit" do
    it "must get edit page for existing product" do
      #Act
      product = Product.create(name: 'Python', description: 'Gain Python skills')
      get edit_product_path(product.id)
  
      # Assert
      must_respond_with :success
    end
  
    it "will respond with not_found when a product does not exist" do
      # Act
      get edit_product_path(-1)
  
      # Assert
      must_respond_with :redirect
    end
  end

  describe "update" do
  end

  describe "destroy" do
  end
end
