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

  def show
    @ride = Ride.find_by_id(params[:id])
    if @ride
      @ride_transactions = @ride.ride_transactions.where("isactive = :v", {v: true})
      render 'show'
    else
      render file: 'public/404.html', status: 404
    end
  end

  def edit
    @ride = Ride.find_by_id(params[:id])
    if not @ride.isactive 
      flash[:info] = "This ride has been canceled by you!"
      redirect_to root_path
    elsif @ride.timeofride < Time.now
      flash[:info] = "This ride has already been completed!"
      redirect_to root_path
    end
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
    @inactive_rides = inactive_rides current_user.id
    if @rides.length || @inactive_rides.length
      @completed_count = completed_count current_user.id
      @future_count = future_count current_user.id
      @inactive_count = inactive_count current_user.id
    end
  end

  def destroy
    @ride = Ride.find(params[:id])
    if @ride.timeofride < Time.now
      flash[:info] = "This ride has already been completed!"
      redirect_to rides_path
    elsif @ride.update_attribute("isactive", false)
      @ride.ride_transactions.update_all(isactive: false)
      @future_count = future_count current_user.id
      @inactive_count = inactive_count current_user.id
      @completed_count = completed_count current_user.id
      respond_to do |format|
        format.html { redirect_to rides_path, info: "Ride canceled successfully." }
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
