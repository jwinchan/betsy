class UsersController < ApplicationController
  before_action :find_user, except: [:create, :destroy]

  def show_products
    if @user.nil?
      render_404
      return
    end
  end

  def show_fulfillments
    if @user.nil?
      render_404
      return
    end
  end

  def show
    if @user.nil?  #probably needs a redirect?
      render_404
      return
    elsif session[:user_id] != @user.id  
      flash[:error] = "You cannot see other users' information."
      redirect_to root_path
      return
    end
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    user = User.find_by(uid: auth_hash[:uid], provider: "github")

    if user
      flash[:success] = "Logged in as returning user #{user.name}"
    else
      user = User.build_from_github(auth_hash)
      
      if user.save
        flash[:success] = "Logged in as new user #{user.name}"
      else
        flash[:error] = "Could not create new user account: #{user.errors.messages}"
        return redirect_to root_path
      end
    end

    session[:user_id] = user.id
    return redirect_to root_path
  end

  def edit
    if @user.nil?
      flash[:error] = "User not found"
      redirect_to root_path
      return
    elsif @user.id != session[:user_id]
      flash[:error] = "You must log in as this user."
      redirect_to root_path
      return
    end
  end

  def update
    if @user.nil?
      flash[:error] = "User not found"
      redirect_to users_path
      return
    elsif @user.update(user_params)
      flash[:success] = "User updated successfully"
      redirect_to user_path
      return
    else
      flash.now[:error] = "Something happened. User not updated."
      render :edit, status: :bad_request
      return
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Successfully logged out!"

    redirect_to root_path
  end


  private

  def find_user
    @user = User.find_by(id: params[:id])
  end

  def user_params
    return params.require(:user).permit(:name, :description, :uid, :provider, :email)
  end
end
