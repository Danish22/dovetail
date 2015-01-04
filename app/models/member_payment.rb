class MemberPayment < Payment
  belongs_to :recipient, class_name: 'Member', touch: true
  belongs_to :sender, class_name: 'Space', touch: true

  # Virtual attribute
  attr_accessor :invoice_id
end
