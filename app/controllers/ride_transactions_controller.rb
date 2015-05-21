class RideTransactionsController < ApplicationController
	
	before_filter :require_user
	before_filter :correct_user, only: [:edit, :destroy, :update]

	def index
		@ride_transactions  = current_user.ride_transactions
	    @completed_count = completed_transaction_count current_user.id
	    @future_count = future_transaction_count current_user.id
	    @inactive_count = inactive_transaction_count current_user.id
	end

	def new
		@ride_transaction = RideTransaction.new
		@rides = rides_for_transaction current_user.id
	end

	def create
		@ride = Ride.find(params[:ride_id])
		if @ride && @ride.save
			@ride_transaction = current_user.ride_transactions.build(ride_transaction_params)
		    if @ride_transaction.save
		      flash[:info] = "Ride share registered!"
		      redirect_to root_path
		    else
		      render 'new'
		    end
		else
			render 'new'
		end
	end
	
	def getRideData
		@ride = Ride.find(params[:id])
	    if @ride
	        if request.xhr?
	    		render partial: 'ride'
			else
				render file: 'public/404.html', status: 403
			end
		end
	end

	private
		def ride_transaction_params
			params.require(:ride_transaction).permit(:ride_id, :from_address, :to_address, :timeofride, 
		        :from_latitude, :to_latitude, :from_longitude, :to_longitude, :timeofride)
		end

		def correct_user
			ride_transaction = RideTransaction.find_by_id(params[:id])
		    if ride_transaction.nil? || current_user.id != ride_transaction.user_id
		        flash[:notice] = "You do not have access to this page"
		        redirect_to root_path
		        return false
		    end
		end
end