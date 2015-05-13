class RidesController < ApplicationController
  def new
    @ride = Ride.new
  end

  def create
    @ride = Ride.new(ride_params)
    if @ride.save
      flash[:info] = "Ride registered!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @ride = Ride.find(params[:id])
  end

  def update
    @ride = Ride.find(params[:id])
    if @ride.update_attributes(ride_params)
      flash[:info] = "Ride updated!"
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    # update to an inactive column
    @ride.find(params[:id]).destroy
  end

  private

    def ride_params
      params.require(:ride).permit(:from_address, :to_address, :timeofride, 
        :car_description, :seats_available)
    end
end
