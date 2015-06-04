class UsersController < ApplicationController
  before_filter :require_no_user, only: [:new, :create]
  before_filter :require_user, only: [:show, :edit, :update, :following, :followers]
  
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
    @user = params[:id] ? User.find(params[:id]) : current_user
  end

  def index
    @users = User.page(params[:page]) 
    # @users = User.where(isactive: true)
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

  def following
    @title = "Following"
    @user  = params[:id] ? User.find(params[:id]) : current_user
    @users = @user.following.paginate(page: params[:page], per_page: 7) 
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = params[:id] ? User.find(params[:id]) : current_user
    @users = @user.followers.paginate(page: params[:page], per_page: 7) 
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end