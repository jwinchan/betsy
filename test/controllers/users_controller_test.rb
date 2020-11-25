require "test_helper"

describe UsersController do

  describe "login" do
    it "can log in" do
      user = perform_login(users(:ada))

      must_respond_with :redirect
    end

    it "can log in a new user" do
      new_user = User.new(uid: "1111", name: "Test", provider: "github", email: "email@gmail.com")

      expect{
      logged_in_user = perform_login(new_user)
      }.must_change "User.count", 1

      must_respond_with :redirect

    end
  end

  describe "logout" do
    it "can logout an existing user" do
      perform_login

      expect(session[:user_id]).wont_be_nil

      delete logout_path

      expect(session[:user_id]).must_be_nil
      must_redirect_to root_path
    end

    it "cannot logout a guest" do
      delete logout_path

      expect(session[:user_id]).must_be_nil
      must_redirect_to root_path
    end
  end


  describe "show" do
    it "responds with success for a logged-in user for their own page" do
      # Arrange
      valid_user = perform_login(users(:ada))
  
      # Act-Assert
      get user_path(valid_user)
      
      expect(session[:user_id]).must_equal valid_user.id
      must_respond_with :success
    end

    it "responds with redirect when guest wants to see users' info" do
      # Arrange
      valid_user_page = users(:ada)

      # Act-Assert
      get user_path(valid_user_page)
      
      expect(session[:user_id]).must_be_nil
      must_redirect_to root_path
    end

    it "responds with redirect when user wants to see other users' info" do
      # Arrange
      valid_user_page = users(:grace)
      invalid_user = perform_login(users(:ada))
      
      # Act-Assert
      get user_path(valid_user_page)
      
      expect(session[:user_id]).must_equal invalid_user.id
      expect(valid_user_page.id).wont_equal invalid_user.id
      must_redirect_to root_path
    end

    it "responds with 404 with an invalid user id" do
      # Arrange
      invalid_user_page = -1

      # Act
      get user_path(invalid_user_page)

      # Assert
      must_respond_with :not_found
    end
  end


  describe "edit" do
    it "responds with success when getting the edit page for an existing user while logged in as that user" do
      # Arrange
      perform_login
      # Act
      get edit_user_path(session[:user_id])

      # Assert
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for an existing user while logged in as different user" do
      # Arrange
      perform_login
      # Ensure there is an existing user saved
      # Act
      get edit_user_path(45)

      # Assert
      must_respond_with :redirect
    end

    it "responds with redirect when getting the edit page for an existing user while not logged in" do
      # Arrange
      user = users(:ada)
      # Ensure there is an existing user saved
      # Act
      get edit_user_path(user.id)

      # Assert
      must_respond_with :redirect
    end

    it "responds with redirect when getting the edit page for a non-existing user" do
      # Arrange
      # Act
      get edit_user_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "update" do
    it "can update an existing user with valid information accurately, and redirect" do
      # Arrange
      user = users(:ada)
      # Set up the form data
      user_hash = {
          user: {
              name: 'new_name',
              email: 'test@gmail.com'
          }
      }

      # Act-Assert
      expect {
        patch user_path(user.id), params: user_hash
      }.wont_differ "User.count"

      # Assert
      must_respond_with :redirect
      must_redirect_to user_path(user.id)

    end

    it "does not update any user if given an invalid id, and responds with a redirect" do
      # Arrange
      # Set up the form data
      id = -1
      user_hash = {
          user: {
              name: 'new_name',
              email: 'email@test.com'
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
