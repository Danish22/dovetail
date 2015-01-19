class InvoicingLineItem < ActiveRecord::Base
  acts_as_line_item
  before_save :ensure_tax_amount
  belongs_to :ledger_item, class_name: 'InvoicingLedgerItem'

  default_scope  { order(:created_at => :asc) }

  def ensure_tax_amount
    self.tax_amount = 0 if self.tax_amount.nil?
  end

  def tax_amount
    r = tax_rate || 0
    
    return net_amount * r / 100
  end

  def net_amount
    q = quantity || 0
    up = unit_price || 0
    return q * up
  end

  def unit_price_formatted
    format_currency_value(unit_price)
  end

end
