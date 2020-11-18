require "test_helper"

describe ProductsController do
  let (:product) {
    Product.create name: "sample product"
  }
  describe "index" do
    it "must get index" do
      get products_index_url
      must_respond_with :success
    end

    it "responds with success when there are many products saved" do
      product
      get products_path
      expect(Product.count).must_equal 1
      must_respond_with :success
    end
    
    it "responds with success when there are no products saved" do
      get products_path
      expect(Product.count).must_equal 0
      must_respond_with :success
    end
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

  describe "new" do
    it "responds with success" do
      # Act
      get new_product_path

      # Assert
      must_respond_with :success

    end
  end

  describe "create" do
    it "can create a new product with valid information accurately, and redirect" do
      # Arrange
      # Set up the form data
      product_hash = {
          product: {
              name: 'Artists Potion',
              stock: 2,
              price: 1400,
              description: 'Turns you into Bob Ross',
          }
      }

      # Act-Assert
      # Ensure that there is a change of 1 in product.count
      expect {
        post products_path, params: product_hash
      }.must_change "Product.count", 1

      # Assert
      # Find the newly created product, and check that all its attributes match what was given in the form data
      # Check that the controller redirected the user
      new_product = Product.find_by(name: product_hash[:product][:name])
      expect(new_product.price).must_equal product_hash[:product][:price]
      expect(new_product.stock).must_equal product_hash[:product][:stock]
      expect(new_product.description).must_equal product_hash[:product][:description]

      must_respond_with :redirect
      must_redirect_to product_path(new_product.id)

    end

    it "does not create a product if the form data violates product validations" do
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Set up the form data so that it violates product validations
      product_hash = {
          product: {
              category: '',
              title: '',
              creator: 'test author',
              publication_year: '1984',
              decription: 'this is a test'
          }
      }
      # Act-Assert
      expect {
        post products_path, params: product_hash
      }.wont_differ "Product.count"

    end
  end

end
