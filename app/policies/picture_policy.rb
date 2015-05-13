class PicturePolicy < ApplicationPolicy
  attr_reader :user, :picture

  def initialize(user, picture)
    @user = user
    @picture = picture
  end

  def create?
  	picture.user_id == user.try(:id)
  end

  def destroy?
  	picture.user_id == user.try(:id)
  end

end