class PlanResource < ActiveRecord::Base
  belongs_to :plan
  belongs_to :resource
end
