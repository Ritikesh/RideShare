class Ride < ActiveRecord::Base

	belongs_to :user
	
	geocoded_by :geocode_user_addresses
	before_validation :geocode

	validates :from_address, presence: true
	validates :to_address, presence: true

	validates :car_description, presence: true, length: { maximum: 100 }
	validates :seats_available, numericality: { only_integer: true, less_than_or_equal_to: 10, 
												greater_than: 0 }
	validate :validate_timeofride
	#validate :location_check

	private
		def geocode_user_addresses
			unless from_address.blank? || to_address.blank?
				from_coordinates = Geocoder.search(from_address)
				to_coordinates = Geocoder.search(to_address)
				self.from_latitude = from_coordinates[0].geometry["location"]["lat"]
				self.from_longitude = from_coordinates[0].geometry["location"]["lng"]
				self.to_latitude = to_coordinates[0].geometry["location"]["lat"]
				self.to_longitude = to_coordinates[0].geometry["location"]["lng"]
			end
		end

		# def location_check
		# 	unless from_address.blank?
		# 		errors.add("#{from_address}", "is not a valid location on the Map - #{self.from_latitude}") unless from_latitude
		# 		#errors.add(:from_address, "Must be a valid location on the Map") unless from_longitude
		# 	end
		# 	unless to_address.blank?
		# 		errors.add(:to_address, "Must be a valid location on the Map") unless to_latitude
		# 		#errors.add(:to_address, "Must be a valid location on the Map") unless to_longitude
		# 	end
		# end

		def validate_timeofride
			if (timeofride.to_time < (0.5).hour.from_now)
				errors.add(:timeofride, 'Must be at 30 mins from now.') 
			end
		end
end
