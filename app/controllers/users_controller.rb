class UsersController < ApplicationController
  before_filter :require_no_user, only: [:new, :create]
  before_filter :require_user, only: [:show, :edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:info] = "Account registered!"
      redirect_back_or_default account_url
    else
      render 'new'
    end
  end
  
  def show
    @user = current_user unless params[:id]
    params[:id] = current_user.id unless params[:id]

    @user = User.find(params[:id]) unless @user

    @completed_count = completed_count params[:id]
    @future_count = future_count params[:id]
    @inactive_count = inactive_count params[:id]
  end

  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(user_params)
      flash[:info] = "Account updated!"
      redirect_to account_url
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end