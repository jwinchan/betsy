require "test_helper"

describe ProductsController do
  # let (:product) {
  #   Product.create name: "sample product"
  # }
  describe "index" do
    it "must get index" do
      get products_index_url
      must_respond_with :success
    end

    # it "responds with success when there are many products saved" do
    #   product
    #   get products_path
    #   expect(Product.count).must_equal 1
    #   must_respond_with :success
    # end
    #
    # it "responds with success when there are no products saved" do
    #   get products_path
    #   expect(Product.count).must_equal 0
    #   must_respond_with :success
    # end
  end

  it "must get show" do
    get products_show_url
    must_respond_with :success
  end

  it "must get new" do
    get products_new_url
    must_respond_with :success
  end

  it "must get edit" do
    get products_edit_url
    must_respond_with :success
  end

end
