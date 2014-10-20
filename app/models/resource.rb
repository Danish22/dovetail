class Resource < ActiveRecord::Base
  belongs_to :space
  belongs_to :location

  has_many :plan_resources
  has_many :plans, through: :plan_resources

end
