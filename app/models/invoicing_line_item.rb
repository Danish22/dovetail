class InvoicingLineItem < ActiveRecord::Base
  acts_as_line_item
  before_save :ensure_tax_amount
  belongs_to :ledger_item, class_name: 'InvoicingLedgerItem'

  default_scope  { order(:created_at => :asc) }

  def ensure_tax_amount
    self.tax_amount = 0 if self.tax_amount.nil?
  end
end
