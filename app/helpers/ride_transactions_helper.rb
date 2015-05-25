module RideTransactionsHelper
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
end
