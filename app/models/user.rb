class User < ActiveRecord::Base
  devise :database_authenticatable, 
         :registerable,
         :recoverable, 
         :rememberable, 
         :trackable,  
         :validatable, 
         :omniauthable
  include DeviseTokenAuth::Concerns::User
  has_and_belongs_to_many :chatrooms
  has_many :messages
end
