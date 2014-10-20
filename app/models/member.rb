class Member < ActiveRecord::Base

  belongs_to :space  
  belongs_to :user   # Admin who created the member record.
  belongs_to :location
  belongs_to :plan

  include Gravtastic
  gravtastic

  validates :name, presence: true
  validates :email, presence: true

end
