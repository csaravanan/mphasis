class ControlMeasure < ActiveRecord::Base

	# Associations
	belongs_to :risk
	belongs_to :risk_scoring

	before_save :check_empty_params
	before_update :check_empty_params

	 validates :threat, presence:true, length: { in: 0..250 }
   validates :consequence, presence:true, length: { in: 0..250 }
   validates :effectiveness, presence:true, length: { in: 0..250 }

	def check_empty_params
		self.control_ids = self.control_ids.reject{|x| !x.present?}
		self.process_ids = self.process_ids.reject{|x| !x.present?}
		self.procedure_ids = self.procedure_ids.reject{|x| !x.present?}
	end
end
