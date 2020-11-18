require "test_helper"

describe UsersController do

  describe "show" do
    it "responds with success when showing user its own info" do
      # Arrange
      skip
      # need login_data

      # Act
      get "/users/#{ valid_user.id }"

      # Assert
      expect(valid_user).wont_be_nil
      expect(session[:user_id]).must_equal valid_user.id
      must_respond_with :success
    end

    it "responds with 404 with an invalid passenger id" do
      # Arrange
      invalid_user_id = -1

      # Act
      get "/users/#{ invalid_user_id }"

      # Assert
      must_respond_with :not_found
    end

    it "responds with redirect when user wants to see other users' info" do
      # Arrange
      skip
      # need login_data
      user = users(grace)
      session[:user_id] = user.id
      invalid_view = users(:ada)

      # Act 
      get "/users/#{ invalid_view.id }"
      
      # Assert
      must_redirect_to user_path(user.id)
    end
  end 

  it "must get edit" do
    skip
    get users_edit_url
    must_respond_with :success
  end

end
