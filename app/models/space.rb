class Space < ActiveRecord::Base

  belongs_to :user

  has_many :user_spaces
  has_many :users, through: :user_spaces

end
