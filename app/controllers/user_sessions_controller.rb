class UserSessionsController < ApplicationController  
  def new
    @user_session = User.new
  end

  def create
    @user_session = UserSession.new params.require(:user)
      .permit(:email, :password)
    if @user_session.save
      flash[:info] = "Successfully logged in!"
      redirect_back_or_default root_path
    else
      # not working!!
      @user_session.errors[:base] << "Incorrect user credentials"
      redirect_to login_path
    end
  end

  def destroy
    current_user_session.destroy
      flash[:info] = "Successfully logged out!"
    redirect_to root_path
  end
end  