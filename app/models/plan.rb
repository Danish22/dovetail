class Plan < ActiveRecord::Base
  belongs_to :space, touch: true
  belongs_to :location, touch: true

  has_many :plan_resources
  has_many :resources, through: :plan_resources

  def self.frequencies
    [
     ["One time", "0"],
     ["Monthly", "1"],
     ["Quarterly", "3"],
     ["Semi Annually", "6"],
     ["Annually", "12"]
    ]
  end

end
