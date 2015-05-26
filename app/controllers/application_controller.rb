class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	helper_method :current_user_session, :current_user, :require_user, :require_no_user,
		:redirect_back_or_default, :store_location, :rides, :rides_search, :inactive_rides,
		:ride_transactions, :inactive_ride_transactions

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

	    def rides_search(timeofride)
	    	before = timeofride.to_time - 60*60
	    	after = timeofride.to_time + 60*60
	    	rides = Ride.where("isactive = :t and timeofride between :u and :v and 
	    		seats_remaining > :w and user_id <> :x", 
	    		{t: true, u: before, v: after, w: 0, x: current_user.id})
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