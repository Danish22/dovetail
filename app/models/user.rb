class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :created_spaces, class: Space
  has_many :created_mmebers, class: Member

  has_many :user_spaces
  has_many :spaces, through: :user_spaces

end
