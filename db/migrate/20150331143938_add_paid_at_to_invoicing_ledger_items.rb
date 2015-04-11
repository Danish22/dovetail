class AddPaidAtToInvoicingLedgerItems < ActiveRecord::Migration
  def change
    add_column :invoicing_ledger_items, :paid_at, :datetime
  end
end
