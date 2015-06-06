class StaticPagesController < ApplicationController
  def home
  	if current_user
  		render 'userhome'
  	else
  		render 'home'
  	end
  end

  def contact
  end

  def about
  end

  def help
  end

end
