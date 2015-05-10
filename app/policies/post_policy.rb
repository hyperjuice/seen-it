class PostPolicy < ApplicationPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def show?
    post.user_id == user.try(:id)
  end

  def edit?
    show?
  end

  def update?
  	show?
  end

  def destroy?
    show?
  end
end
