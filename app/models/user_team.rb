class UserTeam < ActiveRecord::Base

    #associations
	belongs_to :user
	belongs_to :team
end
