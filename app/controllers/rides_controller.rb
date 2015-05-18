class RidesController < ApplicationController
  
  before_filter :require_user
  before_filter :correct_user, only: [:edit, :destroy, :update]

  def new
    @ride = Ride.new
  end

  def create
    @ride = current_user.rides.build(ride_params)
    if @ride.save
      flash[:info] = "Ride registered!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @ride = Ride.find_by_id(params[:id])
  end

  def update
    @ride = Ride.find_by_id(params[:id])
    if @ride.update_attributes(ride_params)
      flash[:info] = "Ride updated!"
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def index
    @rides = rides current_user.id
    @completed_count = completed_count current_user.id
    @future_count = future_count current_user.id
    @inactive_count = inactive_count current_user.id
  end

  def destroy
    @ride = Ride.find(params[:id])
    if @ride.update_attribute("isactive", false)
      @future_count = future_count current_user.id
      @inactive_count = inactive_count current_user.id
      @completed_count = completed_count current_user.id
      respond_to do |format|
        format.html { redirect_to rides_path }
        format.js 
      end
    else
      #render text: "hello world"
    end
  end

  private

    def ride_params
      params.require(:ride).permit(:from_address, :to_address, :timeofride, 
        :car_description, :seats_available, :from_latitude, :to_latitude, :from_longitude,
        :to_longitude)
    end

    def correct_user
      ride = Ride.find_by_id(params[:id])
      if ride.nil? || current_user.id != ride.user_id
        flash[:notice] = "You do not have access to this page"
        redirect_to root_path
        return false
      end
    end
end
