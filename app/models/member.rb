class Member < ActiveRecord::Base

  belongs_to :space  # Primary Space (Membership is via SpaceMembers below)
  belongs_to :user   # Admin who created the member record.

  has_many :space_members
  has_many :spaces, through: :space_members

  has_many :location_members
  has_many :spaces, through: :location_members

  validates :name, presence: true
  validates :email, presence: true

end
