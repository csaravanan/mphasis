class Plan < ActiveRecord::Base
	belongs_to :company
	belongs_to :subscription
	
	delegate :user_count, to: :subscription, prefix: true, allow_nil: true
	delegate :section_ids, to: :subscription, prefix: true, allow_nil: true

end