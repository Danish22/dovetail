class Meetingroom < ActiveRecord::Base

  belongs_to :user
  belongs_to :space
  belongs_to :location

  has_many :bookings

end
