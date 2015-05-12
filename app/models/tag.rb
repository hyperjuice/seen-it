class Tag < ActiveRecord::Base
	validates :category, presence: true
	validates :category, uniqueness: true

	belongs_to :post
	has_many :posts
end
