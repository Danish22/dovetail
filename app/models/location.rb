class Location < ActiveRecord::Base
  belongs_to :space

  has_many :members

  def description
    self.name || "#{self.address}, #{self.city}, #{self.state} "
  end

  def to_s
    description
  end
end
