class AddParentIdToInvoicingLedgerItems < ActiveRecord::Migration
  def change
    add_column :invoicing_ledger_items, :parent_id, :integer
  end
end
