class QuestionOption < ActiveRecord::Base
	belongs_to :nc_question
	delegate :name, to: :response_priority, prefix: true, allow_nil: :true

end
