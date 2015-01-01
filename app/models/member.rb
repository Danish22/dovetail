class Member < ActiveRecord::Base

  belongs_to :space  
  belongs_to :user   # Admin who created the member record.
  belongs_to :location
  belongs_to :plan

  # Collection of all ledger items for this member
  has_many :ledger_items, :foreign_key => 'recipient_id', class_name: 'InvoicingLedgerItem'

  # Collections of ledger items by type.
  has_many :member_invoices, :foreign_key => 'recipient_id', class_name: 'MemberInvoice'
  has_many :member_payments, :foreign_key => 'recipient_id', class_name: 'MemberPayment'
  has_many :member_credit_notes, :foreign_key => 'recipient_id', class_name: 'MemberCreditNote'

  after_save :create_invoice_when_plan_changes

  include Gravtastic
  gravtastic

  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true
  validates :email, presence: true

  attr_accessor :payment_system_token # Represents the card, only present when setting up or updating subscription
  attr_accessor :gateway_error        # Holds any error from the payment gateway

  protected

  def create_invoice_when_plan_changes
    if self.plan_id_changed? && !self.plan_id_change[1].nil?

      invoice = self.member_invoices.new

      invoice.description = "Initial #{plan.name} plan subscription"

      invoice.sender = self.space
      invoice.status = "open"
      invoice.issue_date = Time.now
      invoice.due_date = invoice.issue_date
      invoice.currency = self.location.currency
      
      invoice.plan_id = self.plan_id

      # Line items
      count = 10
      
      if plan.setup_fee.present?
        count -= 1
        invoice.line_items.build({net_amount: plan.setup_fee, tax_amount: tax(plan.setup_fee), description: "#{plan.name} setup fee"})
      end

      if plan.deposit.present?
        count -= 1
        invoice.line_items.build({net_amount: plan.deposit,  tax_amount: tax(plan.deposit), description: "#{plan.name} deposit"})
      end

      if plan.base_price.present?
        count -= 1
        invoice.line_items.build({net_amount: plan.base_price,  tax_amount: tax(plan.base_price), description: "Plan #{plan.name} subscription fee"})
      end

      # Pad invoice with blank rows for later editing.
      (1..count).each do |c|
        invoice.line_items.build()
      end

      invoice.save
    end  # plan_id_changed?
  end

  def tax(amount)
    amount * location.tax_rate / 100
  end
end
