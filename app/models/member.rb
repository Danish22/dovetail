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

  include Gravtastic
  gravtastic

  validates :name, presence: true
  validates :email, presence: true

  attr_accessor :payment_system_token # Represents the card, only present when setting up or updating subscription
  attr_accessor :gateway_error        # Holds any error from the payment gateway
end
