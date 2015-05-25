module RidesHelper
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
end
