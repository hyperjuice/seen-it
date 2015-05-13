class PicturesController < ApplicationController
	def create
		@picture = Picture.create(picture_params)
		redirect_to @picture.user	
	end

def destroy
	@picture = Picture.find(params[:id])
	@user = @picture.user
	@picture.destroy
	redirect_to @user
end

private
	def picture_params
		params.require(:picture).permit(:file, :user_id)
	end

end
