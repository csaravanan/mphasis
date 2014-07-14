class Privilege < ActiveRecord::Base
	
	# Rails Association
	belongs_to :role
	belongs_to :user
	belongs_to :modular

    delegate :model_name, :action_name, to: :modular, prefix: true
    delegate :title, to: :role, prefix: true
end
