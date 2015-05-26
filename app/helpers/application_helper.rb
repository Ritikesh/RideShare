module ApplicationHelper
	def title(title)
		if title.blank?
			"RideShare"
		else
			"RideShare | #{title}"
		end
	end

	def money_saved
		RideTransaction.where(["isactive = :v", {v: true}]).sum(:cost).round(2)
	end

	def fuel_saved
		(RideTransaction.where(["isactive = :v", {v: true}]).sum(:distance) / 10).round(2)
	end
end
