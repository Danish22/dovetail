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

  # When displaying a country to users/members (ie on invoices/reciepts)
  def country_name
    c = ISO3166::Country[self.country]
    c.translations[I18n.locale.to_s] || c.name
  end

end
