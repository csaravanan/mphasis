module PlansHelper

	def plan_validity_period(period)
		if period == 1
			'Year(s)'
		elsif period == '2'
			'Month(s)'
		else
			'Day(s)'
		end
	end
	
	def company_modules(subscription)
		Section.where("id IN (?)",subscription.section_ids).map(&:name).join(",")
	end
end
