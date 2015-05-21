class StaticPagesController < ApplicationController
  def home
  	@rides = rides 
    @completed_count = completed_count 
    @future_count = @rides.length
    @inactive_count = inactive_count
  end

  def contact
  end

  def about
  end

  def help
  end
end
