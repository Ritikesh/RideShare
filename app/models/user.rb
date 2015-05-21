class User < ActiveRecord::Base  
	has_many :rides
	has_many :ride_transactions
	acts_as_authentic 
end 