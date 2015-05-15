class PicturesController < ApplicationController
	def create
		@picture = Picture.new(picture_params)
		authorize @picture
		@picture = @picture.save
		@user = current_user
		redirect_to @user	
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
