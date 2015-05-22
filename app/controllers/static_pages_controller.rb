class StaticPagesController < ApplicationController
  def home
  	@rides_count = Ride.all.count 
    @rides_shared_count = RideTransaction.all.count 
    @money = 'XXX'
    @fuel = 'YYY'
  end

  def contact
  end

  def about
  end

  def help
  end
end
