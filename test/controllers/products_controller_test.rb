require "test_helper"

describe ProductsController do
  describe "not destroy" do
    it "must get index" do
      skip
      get products_index_url
      must_respond_with :success
    end

    it "must get show" do
      skip
      get products_show_url
      must_respond_with :success
    end

    it "must get new" do
      skip
      get products_new_url
      must_respond_with :success
    end

    it "must get edit" do
      skip
      get products_edit_url
      must_respond_with :success
    end
  end  

  describe "destroy" do
    it "can destroy product when the user is merchant" do
      # Arrange
      skip
      valid_user = users(:ada)
      valid_product = products(:confidence)
      
      # Act-Assert
      expect {
        delete product_path(valid_product)
      }.must_differ "Product.count", 1
      
      expect(valid_product.user_id).must_equal valid_user.id
      must_redirect_to user_path(valid_user.id)
    end

    it "cannot destroy product without user login" do
      skip
      # Arrange
      # Need @current_user
      valid_product = products(:confidence)

      # Act-Assert
      expect {
        delete product_path(valid_product)
      }.wont_change "Product.count"

      # Assert
      
      # Check later!
      must_redirect_to login_path
    end

    it "cannot delete product when the user is not its seller" do
      skip
      # Leave it to user site?
    end
  end
end
