class MemberInvoice < Invoice
  belongs_to :recipient, class_name: 'Member', touch: true
  belongs_to :sender, class_name: 'Space', touch: true

  def paid?
    balance <= 0 || status == "cancelled"
  end

  def balance
    return 0 if status == "cancelled"
    total_amount - children.in_effect.sum(:total_amount)
  end

  def balance_formatted
    format_currency_value(balance)
  end

end
