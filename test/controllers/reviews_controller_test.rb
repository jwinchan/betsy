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

    it "responds with redirect when reviewer is logged-in merchant" do
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
        post product_reviews_path(product_id: invalid_product), params: valid_review
      }.wont_change 'Review.count'
       
      must_respond_with :redirect
    end

    it "cannot add review to an existing product when reviewer is logged-in merchant" do
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
        post product_reviews_path(product_id: product.id), params: invalid_review
      }.wont_change 'Review.count'
       
      must_respond_with :redirect
    end
  end

  describe "edit" do
    it "responds with success when getting the edit page for an existing review" do
      # Arrange
      review1 = reviews(:review1) # review for confidence
      
      # Act
      get edit_review_path(review1)

      # Assert
      must_respond_with :success
    end

    it "responds with redirect when the review editor is logged-in merchant" do
      # Arrange
      invalid_reviewer = perform_login(users(:ada))
      review1 = reviews(:review1) # review for confidence
      
      # Act
      get edit_review_path(review1)

      # Assert
      must_respond_with :redirect
    end

    it "responds with redirect when a review is not existed" do
      # Arrange
      invalid_review = -1

      # Act
      get edit_review_path(invalid_review)

      # Assert
      must_respond_with :not_found
    end
  end

  describe "update" do
    it "can update review to an existing product" do
      # Arrange
      review1 = reviews(:review1) # review for confidence, rating 3 

      # Act & Assert
      expect {
        patch review_path(review1), params: valid_review
      }.wont_change 'Review.count'

      review = Review.find_by(id: review1.id)
      expect(review).must_equal review1
      expect(review.rating).wont_equal review1.rating
      expect(review.rating).must_equal 5
    end

    it "cannot update review to an existing product when reviewer is logged-in merchant" do
      # Arrange
      invalid_reviewer = perform_login(users(:ada))
      review1 = reviews(:review1)   # merchant is Ada, rating is 3
      initial_rating = review1.rating

      # Act & Assert
      expect {
        patch review_path(review1), params: valid_review
      }.wont_change 'Review.count'

      review1.reload
      expect(review1.rating).must_equal initial_rating 
      must_respond_with :redirect
    end

    it "cannot update a review when the review is not existed" do
      # Arrange
      invalid_review = -1

      # Act
      expect {
        patch review_path(invalid_review), params: valid_review
      }.wont_change 'Review.count'

      # Assert
      must_respond_with :not_found
    end

    it "cannot update review with invalid rating" do
      # Arrange
      review1 = reviews(:review1)
      initial_rating = review1.rating

      # Act & Assert
      expect {
        patch review_path(review1), params: invalid_review
      }.wont_change 'Review.count'

      review1.reload
      expect(review1.rating).must_equal initial_rating 
      must_respond_with :redirect
    end
  end

  describe "destroy" do
  end
end
