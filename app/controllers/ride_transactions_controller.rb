class RideTransactionsController < ApplicationController
	
	before_filter :require_user
	before_filter :correct_user, only: [:edit, :destroy, :update]

	def index
		@ride_transactions  = ride_transactions current_user.id
		@inactive_ride_transactions = inactive_ride_transactions current_user.id

		if @ride_transactions.length || @inactive_ride_transactions.length
		    @completed_count = completed_transaction_count current_user.id
		    @future_count = future_transaction_count current_user.id
		    @inactive_count = inactive_transaction_count current_user.id
		end
	end

	def new
		@ride_transaction = RideTransaction.new
	end

	def create
		@ride = Ride.find_by_id(params[:ride_transaction][:ride_id])
		if @ride
			@ride_transaction = current_user.ride_transactions.build(ride_transaction_params)
			# transactions
			begin
				# transactions?
				if @ride_transaction.save && @ride.save
					flash[:info] = "Ride share registered!"
					redirect_to root_path
				else
					render 'new'
				end
			rescue ActiveRecord::RecordNotUnique
				@ride_transaction.errors[:base] << "You can register only once/Ride."
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
	    		render partial: 'ride' #RideTransaction/_Ride
			else
				render file: 'public/404.html', status: 403
			end
		end
	end

	def search
		if params[:timeofride].to_time
			@rides = rides_search params[:timeofride]
			render json: { rides: @rides}
		else
			render json: { rides: {}}
		end
	end

	def destroy
		@ride_transaction = RideTransaction.find(params[:id])
		if @ride_transaction.timeofride < Time.now
			flash[:info] = "This ride has already been completed!"
			redirect_to ride_transactions_path
		elsif @ride_transaction.update_attribute("isactive", false) && @ride_transaction.ride.save
			@completed_count = completed_transaction_count current_user.id
		    @future_count = future_transaction_count current_user.id
		    @inactive_count = inactive_transaction_count current_user.id
			respond_to do |format|
				format.html { redirect_to ride_transactions_path, info: "Ride canceled successfully." }
				format.js 
			end
		else
			#render text: "hello world"
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