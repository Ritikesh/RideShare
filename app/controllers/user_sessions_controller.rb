class UserSessionsController < ApplicationController  
  def new
    @user = User.new
  end

  def create
    @user_session = UserSession.new params.require(:user)
      .permit(:email, :password)
    if @user_session.save
      redirect_back_or_default root_path
    else
      redirect_to login_path
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to root_path
  end
end  