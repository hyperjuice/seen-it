class UsersController < ApplicationController
	def show
		@user = User.find(params[:id])
		@picture = Picture.new
	end
end
