class PicturesController < ApplicationController
	def create
		@picture = Picture.create(picture_params)
		redirect_to @picture.user	
	end

private
	def picture_params
		params.require(:picture).permit(:file, :user_id)
	end

end
