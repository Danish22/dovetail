class MemberInvoice < Invoice
  belongs_to :recipient, class_name: 'Member'
  belongs_to :sender, class_name: 'Space'
end
