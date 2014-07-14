class HomeController < ApplicationController
  skip_before_filter :authenticate_user!, only: [ :index]
  # Landing Page
	def index
	end
end