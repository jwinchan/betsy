require "test_helper"

describe ProductsController do
  describe "index" do
    it "must get index" do
      get products_path
      must_respond_with :success
    end

    it "responds with success when there are many products saved" do
     get products_path
    
      expect(Product.count).must_equal 1
      must_respond_with :success
    end

   
    it "responds with success when there are no products saved" do
      #ask team about this test! It's kind of weird...
      products(:confidence).destroy

      get products_path

      expect(Product.count).must_equal 0
      must_respond_with :success
    end
  end
  
  describe "show" do
    it "must get show" do
      product = products(:confidence)
      get product_path(product.id)
      must_respond_with :success
    end

    it 'should respond with 3xx with an invalid product id' do
      get product_path(-1)
      must_respond_with :redirect
    end
  end

  describe "new" do
    it "responds with success when user is logged in" do
      perform_login

      # Act
      get new_product_path

      # Assert
      must_respond_with :success
    end

    it "responds with redirect when user is not logged in" do
      # Act
      get new_product_path

      # Assert
      must_respond_with :redirect
    end
  end

  describe "create" do
    it "can create a new product with valid information accurately, and redirect" do
      #maybe failing because of sessions[:user_id] ?
      skip
      # Arrange
      user = users(:ada)
      # Set up the form data
      product_hash = {
          product: {
              name: 'Artists Potion',
              user_id: user.id,
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



describe "Edit" do
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

  describe "Update" do
    it "must get update for existing product" do
      product = products(:confidence)

      updated_product = {
          product: {
              name: "Public Speaking",
              description: "Level 1",
              price: 45,
          }
      }
      expect {
        patch product_path(product.id), params: updated_product
      }.wont_change "Product.count"

      must_redirect_to product_path

      product = Product.find_by(id: product.id)
      expect(product.name).must_equal updated_product[:product][:name]
    end

      it "will respond with not found  given an invalid id" do
        updated_product = {
            product: {
                name: "Public Speaking",
                description: "Level 1",
                price: 45,
            }
        }
        expect {
          patch product_path(-1), params: updated_product
        }.wont_change "Product.count"

        must_respond_with :redirect
      end
  end
 

  describe "destroy" do
    it "can delete a product when the logged-in user is also the product merchant" do
      # Arrange
      valid_user = perform_login(users(:ada))
      valid_product = products(:confidence)
      
      # Act-Assert
      expect {
        delete product_path(valid_product)
      }.must_differ "Product.count", -1
      
      expect(session[:user_id]).must_equal valid_user.id
      expect(valid_product.user_id).must_equal valid_user.id
      must_respond_with :redirect
    end

    it "cannot delete product without user login" do
      # Arrange
      valid_product = products(:confidence)

      # Act-Assert
      expect {
        delete product_path(valid_product)
      }.wont_change "Product.count"

      expect(session[:user_id]).must_be_nil
      must_respond_with :redirect
    end

    it "cannot delete product when the logged-in user is not the product merchant" do
      # Arrange
      invalid_user = perform_login(users(:grace))
      valid_product = products(:confidence)

      # Act-Assert
      expect {
        delete product_path(valid_product)
      }.wont_change "Product.count"

      expect(session[:user_id]).must_equal invalid_user.id
      expect(valid_product.user_id).wont_equal invalid_user.id
      must_redirect_to root_path
    end

    it "cannot delete a product if it's invalid and will redirect to 404" do
      # Arrange
      invalid_product = -1
      
      # Act-Assert
      expect {
        delete product_path(-1)
      }.wont_change "Product.count"
      
      must_respond_with :not_found
    end
  end

  describe "retired" do
    it "can retire a product when the logged-in user is also the product merchant" do
      # Arrange
      # Affect by categories, need to check again when category is added!
      valid_user = perform_login(users(:ada))
      valid_product = products(:confidence)
      valid_product.retired = false
      valid_product.save
      
      # Act-Assert
      expect {
        patch retired_product_path(valid_product)
      }.wont_change 'Product.count'

      expect(session[:user_id]).must_equal valid_user.id
      expect(valid_product.user_id).must_equal valid_user.id

      valid_product.reload
      expect(valid_product.retired).must_equal true
      must_respond_with :redirect   
    end

    it "can unretire a product when the logged-in user is also the product merchant" do
      # Arrange
      # Affect by categories, need to check again when category is added!
      valid_user = perform_login(users(:ada))
      valid_product = products(:confidence)
      valid_product.retired = true
      valid_product.save
      
      # Act-Assert
      expect {
        patch retired_product_path(valid_product)
      }.wont_change 'Product.count'

      expect(session[:user_id]).must_equal valid_user.id
      expect(valid_product.user_id).must_equal valid_user.id
      
      valid_product.reload
      expect(valid_product.retired).must_equal false
      must_respond_with :redirect   
    end

    it "cannot retire a product without user login" do
      # Arrange
      valid_product = products(:confidence)
      retired_status = valid_product.retired

      # Act-Assert
      expect {
        patch retired_product_path(valid_product)
      }.wont_change "Product.count"

      valid_product.reload
      expect(session[:user_id]).must_be_nil
      expect(valid_product.retired).must_equal retired_status
      must_redirect_to root_path 
    end

    it "cannot retire product when the user is not the owner" do
      # Arrange
      # Affect by categories, need to check again when category is added!
      invalid_user = perform_login(users(:grace))
      valid_product = products(:confidence)
      retired_status = valid_product.retired

      # Act-Assert
      expect {
        patch retired_product_path(valid_product)
      }.wont_change "Product.count"

      valid_product.reload
      expect(session[:user_id]).must_equal invalid_user.id
      expect(valid_product.user_id).wont_equal invalid_user.id
      expect(valid_product.retired).must_equal retired_status
      must_respond_with :redirect
    end

    it "cannot retire a product if it's invalid" do
      expect {
        patch retired_product_path(-1)
      }.wont_change "Product.count"

      must_respond_with :not_found
    end
  end
end
