class Ride < ActiveRecord::Base

	belongs_to :user
	
	validates :from_address, presence: true
	validates :to_address, presence: true
	
	validates :from_latitude, numericality: true
	validates :from_longitude, numericality: true
	validates :to_latitude, numericality: true
	validates :to_longitude, numericality: true

	validates :car_description, presence: true, length: { maximum: 100 }
	validates :seats_available, numericality: { only_integer: true, less_than_or_equal_to: 10, 
												greater_than: 0 }
	validate :validate_timeofride
	
	private
		def validate_timeofride
			if (timeofride.to_time < (0.5).hour.from_now)
				errors.add(:timeofride, 'Must be at 30 mins from now.') 
				return false
			end
		end
end
