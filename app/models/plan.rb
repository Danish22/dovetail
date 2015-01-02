class Plan < ActiveRecord::Base
  belongs_to :space
  belongs_to :location

  has_many :plan_resources
  has_many :resources, through: :plan_resources

  def self.frequencies
    [
     ["Monthly", "1"],
     ["Quarterly", "3"],
     ["Semi Annually", "6"],
     ["Annually", "12"]
    ]
  end

end
