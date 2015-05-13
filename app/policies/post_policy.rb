class PostPolicy < ApplicationPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def show?
    true
  end

  def edit?
    (post.user_id == user.try(:id)) || (user.try(:id) == 1)
  end

  def update?
  	edit?
  end

  def destroy?
    edit?
  end
end
