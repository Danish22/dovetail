class SpaceMember < ActiveRecord::Base
  belongs_to :space
  belongs_to :member
end
