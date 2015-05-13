class Picture < ActiveRecord::Base
	has_attached_file :file, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :file, :content_type => /\Aimage\/.*\Z/

  belongs_to :user
end
