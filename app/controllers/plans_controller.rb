class PlansController < ApplicationController
	skip_before_filter :authenticate_user!
	def new
		@plan = Plan.new
		@subscriptions = Subscription.all
	end
end