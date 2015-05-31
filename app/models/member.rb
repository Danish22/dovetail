class Member < ActiveRecord::Base

  belongs_to :space, touch: true
  belongs_to :user   # Admin who created the member record.
  belongs_to :location, touch: true
  belongs_to :plan

  has_many :bookings

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

  def tax_rate()
    return 0 if location.tax_rate.nil?
    return location.tax_rate
  end

  def send_invoice(invoice, user)
    PaymentMailer.invoice(user, self, invoice).deliver

    # Schedule starts from the date the Manager sends the first invoice 
    # (this is also called when the system sends subsequent invoices to 
    # trigger the next invoice)
    self.last_scheduled_invoice_at = Time.now
    self.save
  end

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
      count = 7
      
      unless plan.setup_fee.blank?
        count -= 1
        invoice.line_items.build({quantity: 1, unit_price: plan.setup_fee, tax_rate: tax_rate(), description: "#{plan.name} setup fee"})
      end

      unless plan.deposit.blank?
        count -= 1
        invoice.line_items.build({quantity: 1, unit_price: plan.deposit,  tax_rate: tax_rate(), description: "#{plan.name} deposit"})
      end

      unless plan.base_price.blank?
        count -= 1
        invoice.line_items.build({quantity: 1, unit_price: plan.base_price,  tax_rate: tax_rate(), description: "Plan #{plan.name} subscription fee"})
      end

      # Pad invoice with blank rows for later editing.
      (1..count).each do |c|
        invoice.line_items.build()
      end

      invoice.save
    end  # plan_id_changed?
  end

end
