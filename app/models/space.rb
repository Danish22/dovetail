class Space < ActiveRecord::Base
  belongs_to :user

  has_many :user_spaces
  has_many :users, through: :user_spaces

  has_many :created_members, class: Member

  has_many :space_members
  has_many :members, through: :space_members

  # Space is payed for through the connected payment_method
  # but the subscription is local (to support multiple spaces on one payment method).
  belongs_to :payment_method # Plus plan and stripe_subscription_id

  def self.plans
    [
     ["Basic Monthly ($50/Month)", "Basic-M"],
     ["Basic Yearly ($500/Year)", "Basic-Y"]
    ]
  end


end
