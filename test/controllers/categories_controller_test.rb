require "test_helper"

describe CategoriesController do
  describe "create" do
    it "can create a new category when given valid input" do
      category_hash = {
          name: "test category"
      }
      perform_login

      expect {
        post categories_path, params: category_hash
      }.must_change "Category.count", 1

      must_respond_with :redirect
    end

    it "wont save when creating category with invalid input" do
      category_hash = {
          name: nil
      }
      perform_login

      expect {
        post categories_path, params: category_hash
      }.wont_differ "Category.count"

      must_respond_with :redirect
    end
  end
end
