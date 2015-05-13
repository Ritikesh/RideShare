class User < ActiveRecord::Base  
	has_many :rides
	acts_as_authentic 
end 