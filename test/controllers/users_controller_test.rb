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


  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid user" do
      # Arrange
      # Ensure there is an existing user saved
      skip
      # Act
      get edit_user_path(@user.id)

      # Assert
      must_respond_with :success

    end

    it "responds with redirect when getting the edit page for a non-existing user" do
      # Arrange
      skip
      # Act
      get edit_user_path(-1)

      # Assert
      must_respond_with :redirect

    end
  end

  describe "update" do
    it "can update an existing user with valid information accurately, and redirect" do
      skip
      # Arrange
      id = @user.id
      # Set up the form data
      user_hash = {
          user: {
              name: 'new_name'
          }
      }

      # Act-Assert
      expect {
        patch user_path(id), params: user_hash
      }.wont_differ "User.count"

      # Assert
      must_respond_with :redirect
      must_redirect_to user_path(id)

    end

    it "does not update any user if given an invalid id, and responds with a 404" do
      # Arrange
      skip
      # Set up the form data
      id = -1
      user_hash = {
          user: {
              name: 'new_name'
          }
      }

      # Act-Assert
      # Ensure that there is no change in user.count
      expect {
        patch user_path(id), params: user_hash
      }.wont_change "User.count"

      # Assert
      # Check that the controller gave back a 404
      must_respond_with :redirect

    end

  end

end
