class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update]

  def index
  end

  def show
  end

  def edit
    if @user.nil?
      flash[:error] = "User not found"
      redirect_to users_path
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


  private

  def find_user
    @user = User.find_by_id(params[:id])
  end

  def user_params
    return params.require(:user).permit(:name, :description, :uid, :provider, :email)
  end
end
