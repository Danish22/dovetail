class Member < ActiveRecord::Base

  belongs_to :space  # Primary Space (Membership is via SpaceMembers below)
  belongs_to :user   # Admin who created the member record.
  belongs_to :location

  include Gravtastic
  gravtastic

  validates :name, presence: true
  validates :email, presence: true

end
