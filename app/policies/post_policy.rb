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
    post.user_id == user.try(:id)
  end

  def update?
  	post.user_id == user.try(:id)
  end

  def destroy?
    post.user_id == user.try(:id)
  end
end
