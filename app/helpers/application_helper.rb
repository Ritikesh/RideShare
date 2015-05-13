module ApplicationHelper
	def title(title)
		if title.blank?
			"RideShare"
		else
			"RideShare | #{title}"
		end
	end
end
