class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


    validates_presence_of :first_name, :last_name, :profile_name

	has_many :posts	
	 acts_as_voter

	has_many :pictures 
end
