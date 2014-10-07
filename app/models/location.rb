class Location < ActiveRecord::Base
  belongs_to :space

  has_many :location_members
  has_many :members, through: :location_members

  def description
    self.name || "#{self.address}, #{self.city}, #{self.state} "
  end
end
