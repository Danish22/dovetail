class Space < ActiveRecord::Base
  belongs_to :user

  has_many :user_spaces
  has_many :users, through: :user_spaces

  has_many :created_members, class: Member

  has_many :space_members
  has_many :members, through: :space_members

end
