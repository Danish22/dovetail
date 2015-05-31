class Booking < ActiveRecord::Base

  belongs_to :meetingroom

  belongs_to :space
  belongs_to :location
  belongs_to :member

  def starting
    super.in_time_zone(location.timezone) if super && location.timezone
  end

  def ending
    super.in_time_zone(location.timezone) if super && location.timezone
  end
end
