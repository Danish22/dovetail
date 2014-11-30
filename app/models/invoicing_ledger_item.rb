class InvoicingLedgerItem < ActiveRecord::Base

  acts_as_ledger_item
  has_many :line_items, class_name: 'InvoicingLineItem', foreign_key: :ledger_item_id

  accepts_nested_attributes_for :line_items

  def is_invoice
    self.class.is_invoice
  end

  def is_payment
    self.class.is_payment
  end

  def is_credit_note
    self.class.is_credit_note
  end

  # In Dovetail we'll track invoice payments.  Credit notes may be applied to an invoice.
  # To do this we store the invoice id and reference them as child/parents.
  has_many :children, class_name: 'InvoicingLedgerItem', foreign_key: :parent_id
  belongs_to :parent, class_name: 'InvoicingLedgerItem', foreign_key: :parent_id

end
