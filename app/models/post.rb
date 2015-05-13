class Post < ActiveRecord::Base
	belongs_to :user

	acts_as_votable

	belongs_to :tag
	has_many :tags

	validates :name, presence: true
	has_many :comments 
end
