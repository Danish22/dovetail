class Member < ActiveRecord::Base

  belongs_to :space  
  belongs_to :user   # Admin who created the member record.
  belongs_to :location
  belongs_to :plan

  has_many :member_invoices, :foreign_key => 'recipient_id', class_name: 'MemberInvoice'
  has_many :member_payments, :foreign_key => 'recipient_id', class_name: 'MemberPayment'
  has_many :member_credit_notes, :foreign_key => 'recipient_id', class_name: 'MemberCreditNote'

  include Gravtastic
  gravtastic

  validates :name, presence: true
  validates :email, presence: true

end
