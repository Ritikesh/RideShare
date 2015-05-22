class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	helper_method :current_user_session, :current_user, :require_user, :require_no_user,
		:redirect_back_or_default, :store_location, :inactive_count, :completed_count, 
		:future_count, :future_transaction_count, :completed_transaction_count, 
		:rides #, :rides_for_transaction

	private
	    def current_user_session
			return @current_user_session if defined?(@current_user_session)
			@current_user_session = UserSession.find
	    end
	    
	    def current_user
			return @current_user if defined?(@current_user)
			@current_user = current_user_session && current_user_session.record
	    end
	    
	    def require_user
			unless current_user
		        store_location
		        flash[:notice] = "You must be logged in to access this page"
		        redirect_to login_path
		        return false
	      	end
	    end

	    def require_no_user
			if current_user
		        store_location
		        flash[:notice] = "You must be logged out to access this page"
		        redirect_to account_url
		        return false
	      	end
	    end
	    
	    def store_location
	      	session[:return_to] = request.original_url
	    end
	    
	    def redirect_back_or_default(default)
			redirect_to(session[:return_to] || default)
			session[:return_to] = nil
		end

		def inactive_count(userid = nil)
	      	if userid
	      		Ride.where(["isactive = :t and user_id = :u",
	          		{t: false, u: userid}]).count
	      	else
	      		Ride.where(["isactive = :t", {t: false}]).count
	      	end
	    end

	    def future_count(userid = nil)
	    	if userid
	      		Ride.where(["isactive = :t and user_id = :u and timeofride > :v", 
	          		{t: true, u: userid, v: Time.now}]).count
	      	else
	      		Ride.where(["isactive = :t and timeofride > :u", 
	      			{t: true, u: Time.now}]).count
	      	end
	    end

	    def completed_count(userid = nil)
	    	if userid
	      		Ride.where(["isactive = :t and user_id = :u and timeofride < :v", 
        	  		{t: true, u: userid, v: Time.now}]).count
	      	else
	      		Ride.where(["isactive = :t and timeofride < :u", 
	      			{t: true, u: Time.now}]).count
	      	end
	    end

		def inactive_transaction_count(userid = nil)
	      	if userid
	      		RideTransaction.where(["isactive = :t and user_id = :u",
	          		{t: false, u: userid}]).count
	      	else
	      		RideTransaction.where(["isactive = :t", {t: false}]).count
	      	end
	    end

	    def future_transaction_count(userid = nil)
	    	if userid
	      		RideTransaction.where(["isactive = :t and user_id = :u and timeofride > :v", 
	          		{t: true, u: userid, v: Time.now}]).count
	      	else
	      		RideTransaction.where(["isactive = :t and timeofride > :u", 
	      			{t: true, u: Time.now}]).count
	      	end
	    end

	    def completed_transaction_count(userid = nil)
	    	if userid
	      		RideTransaction.where(["isactive = :t and user_id = :u and timeofride < :v", 
        	  		{t: true, u: userid, v: Time.now}]).count
	      	else
	      		RideTransaction.where(["isactive = :t and timeofride < :u", 
	      			{t: true, u: Time.now}]).count
	      	end
	    end

	    def rides_search(timeofride)
	    	before = timeofride.to_time - 60*60
	    	after = timeofride.to_time + 60*60
	    	rides = Ride.where("isactive = :t and timeofride between :u and :v and 
	    		seats_remaining > :w", {t: true, u:before, v: after, w: 0})
	    end

	    def rides(userid = nil)
	    	if userid
	    		rides = Ride.includes(:user).where(["isactive = :t and user_id = :u", 
          	  		{t: true, u: userid}]).order(timeofride: :desc)
	    	else
    			rides = Ride.includes(:user).where("isactive = :t and timeofride > :u and seats_remaining > :v",
					{t: true, u:Time.now, v: 0}).order(:timeofride)
	    	end
	    end

	    def inactive_rides(userid = nil)
	    	if userid
	    		rides = Ride.includes(:user).where(["isactive = :t and user_id = :u", 
          	  		{t: false, u: userid}]).order(timeofride: :desc)
	    	else
	    		nil
	    	end
	    end

	    def ride_transactions(userid = nil)
	    	if userid
	    		ride_transactions = RideTransaction.includes(:user, :ride).where(["isactive = :t and user_id = :u", 
          	  		{t: true, u: userid}]).order(timeofride: :desc)
	    	else
	    		nil
	    	end
	    end

	    def inactive_ride_transactions(userid = nil)
	    	if userid
	    		ride_transactions = RideTransaction.includes(:user, :ride).where(["isactive = :t and user_id = :u", 
          	  		{t: false, u: userid}]).order(timeofride: :desc)
	    	else
	    		nil
	    	end
	    end
end 