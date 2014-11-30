class MemberCreditNote < CreditNote
  belongs_to :recipient, class_name: 'Member'
  belongs_to :sender, class_name: 'Space'

  # Virtual attribute
  attr_accessor :invoice_id
end
