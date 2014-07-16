class Space < ActiveRecord::Base
  belongs_to :user

  has_many :user_spaces, dependent: :destroy
  has_many :users, through: :user_spaces

  has_many :created_members, class: Member, dependent: :destroy

  has_many :space_members, dependent: :destroy
  has_many :members, through: :space_members

  # Space is payed for through the connected payment_method
  # but the subscription is local (to support multiple spaces on one payment method).
  belongs_to :payment_method # Plus plan and stripe_subscription_id

  scope :missing_payment_method, -> { where(payment_method_id: nil) }

  before_destroy :cancel_subscription

  validates :name, presence: true
  validates :address, presence: true
  validates :timezone, presence: true
  validates :currency, presence: true
  validates :plan, presence: true

  def self.plans
    [
     ["Basic Monthly ($50/Month)", "Basic-M"],
     ["Basic Yearly ($500/Year)", "Basic-Y"]
    ]
  end

  def plan_description
    unless plan.blank?
      Space.plans.each do |plan|
        return plan[0] if plan[1] == self.plan
      end
    end
  end

  # TODO Maybe handle (somehow) exception.
  def cancel_subscription
    unless payment_method.nil?
      payment_method.cancel_subscription(self)
    end
  end

end
