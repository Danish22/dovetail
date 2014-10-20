class Plan < ActiveRecord::Base
  belongs_to :space
  belongs_to :location

  has_many :plan_resources
  has_many :resources, through: :plan_resources

end
