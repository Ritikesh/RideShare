class Ride < ActiveRecord::Base

	belongs_to :user
	has_many :ride_transactions

	validates :from_address, presence: true
	validates :to_address, presence: true
	
	validates :from_latitude, numericality: true
	validates :from_longitude, numericality: true
	validates :to_latitude, numericality: true
	validates :to_longitude, numericality: true
	validates :user_id, presence: true

	validates :car_description, presence: true, length: { maximum: 100 }
	validates :seats_available, numericality: { only_integer: true, less_than_or_equal_to: 10, 
												greater_than: 0 }
	validate :validate_timeofride
	validate :seats_remaining_check
	
	before_validation :update_ride_seats_remaining

	private
		def validate_timeofride
			if (timeofride.to_time < (0.5).hour.from_now)
				errors.add(:timeofride, 'Must be at 30 mins from now.') 
				return false
			end
		end

		def seats_remaining_check
			unless seats_remaining
				errors.add(:seats_remaining, 'Seats are full/cannot be reduced now.') 
				return false
			end
		end

		def update_ride_seats_remaining
			self.seats_remaining = self.seats_available - 
					self.ride_transactions.where(["isactive = :t", {t: true}]).count
		end
end
