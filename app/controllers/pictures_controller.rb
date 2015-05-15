class PicturesController < ApplicationController
	def create
		@picture = Picture.new(picture_params)
		authorize @picture
		@picture = Picture.save
		redirect_to @picture.user	
	end

	def destroy
		@picture = Picture.find(params[:id])
		authorize @picture
		@user = @picture.user
		@picture.destroy
		redirect_to @user
	end

private
	def picture_params
		params.require(:picture).permit(:file, :user_id)
	end
end
