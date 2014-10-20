class Location < ActiveRecord::Base
  belongs_to :space

  has_many :members
  has_many :resources
  has_many :plans

  def description
    self.name || "#{self.address}, #{self.city}, #{self.state} "
  end

  def to_s
    description
  end
end
