class Comment < ActiveRecord::Base

	#associations
	belongs_to :commentable, :polymorphic => true
end
