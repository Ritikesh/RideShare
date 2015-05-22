class RideTransaction < ActiveRecord::Base
	belongs_to :user
	belongs_to :ride

	validates :user_id, presence: true
	validates :ride_id, presence: true

	validates :from_address, presence: true
	validates :to_address, presence: true
	
	validates :from_latitude, numericality: true
	validates :from_longitude, numericality: true
	validates :to_latitude, numericality: true
	validates :to_longitude, numericality: true

	validate :validate_timeofride
	before_save :seat_count

	private
		def validate_timeofride
			unless (timeofride.to_time)
				errors.add(:timeofride, 'Must be a valid time.') 
				return false
			end
		end

		def seat_count
			ride = Ride.find(self.ride_id)
			# total seats must be greater than allotted seats
			return ride.seats_available > ride.ride_transactions.count
		end
end
