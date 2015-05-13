class Post < ActiveRecord::Base
	belongs_to :user

	acts_as_votable

	has_and_belongs_to_many :tags

	validates :name, presence: true
	has_many :comments 
end
