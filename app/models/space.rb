class Space < ActiveRecord::Base
  belongs_to :user

  has_many :user_spaces, dependent: :destroy
  has_many :users, through: :user_spaces

  has_many :members, dependent: :destroy

  has_many :locations
  has_many :invites
  has_many :resources
  has_many :plans

  has_many :member_invoices, :foreign_key => 'sender_id', class_name: 'MemberInvoice'
  has_many :member_payments, :foreign_key => 'sender_id', class_name: 'MemberPayment'
  has_many :member_credit_notes, :foreign_key => 'sender_id', class_name: 'MemberCreditNotee'

  has_many :integrations

  accepts_nested_attributes_for :locations

  # Space is paid for through the connected payment_method
  # but the subscription is local (to support multiple spaces on one payment method).
  belongs_to :payment_method # Plus plan and stripe_subscription_id

  scope :missing_payment_method, -> { where(payment_method_id: nil) }

  before_destroy :cancel_subscription

  validates :name, presence: true
  #validates :plan, presence: true

  def cancel_subscription
    if payment_method
      payment_method.cancel_subscription(self)
    end
  end

  def self.plans
    [
     ["Basic Monthly", "Basic-M"],
     ["Basic Yearly", "Basic-Y"]
    ]
  end

  def plan_description
    @plan_descriptions ||= {
      "Basic-M" => "Basic Monthly",
      "Basic-Y" => "Basic Annually"
    }

    if self.plan
      return @plan_descriptions[self.plan]
    else
      return "No plan selected"
    end
  end

  def update_payment_system_customer(member)
    gw = payment_gateway
    raise "No payment gateway has been configured for this space" if gw.nil?

    begin
      gw.update_customer(member)
      return true
    rescue Exception => e
      member.gateway_error = e.message
      return false
    end
  end

  def charge_member(member, amount, description = "")
    gw = payment_gateway
    raise "No payment gateway has been configured for this space" if gw.nil?

    begin
      gw.charge_member(member, amount, member.location.currency, description)
      p = member.member_payments.create(status: "cleared", 
                                        currency: member.location.currency,
                                        sender: self,
                                        description: "Charge succeeded", 
                                        total_amount: amount, 
                                        issue_date: Time.now)
    rescue Exception => e
      # TODO We may wish to log these into a db table/gather metrics on these to help troubleshoot
      Rails.logger.info("Exception from charge member: #{e.inspect}")
      p = member.member_payments.create(status: "failed", 
                                        currency: member.location.currency,
                                        sender: self,
                                        description: "Charge failed: #{e.message}", 
                                        total_amount: amount,
                                        issue_date: Time.now)
    end

    return p
  end

  def payment_gateway
     @payment_gateway ||= integrations.where(type: ['StripeIntegration']).first  
  end

end
