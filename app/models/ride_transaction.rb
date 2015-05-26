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
	before_save :validate_existing_reg
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
			if ride.seats_available > ride.ride_transactions.count
				ride.save
			else
				return false
			end
		end

		def validate_existing_reg
			# for an existing record, there's no edit. hence just skip this validation
			unless self.new_record?
				return true
			end
			ride_transactions = RideTransaction.where(["user_id = :u and ride_id = :v and isactive = :w", {
				u: self.user_id, v: self.ride_id, w: true }]).count
			if ride_transactions > 0
				self.errors[:base] << "You can have only one active registration/ride."
				return false
			else
				return true
			end
		end
end
