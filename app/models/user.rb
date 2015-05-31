class User < ActiveRecord::Base  
	has_many :rides
	has_many :ride_transactions
	acts_as_authentic 
	self.per_page = 15
end 