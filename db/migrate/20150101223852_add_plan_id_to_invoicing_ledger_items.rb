class AddPlanIdToInvoicingLedgerItems < ActiveRecord::Migration
  def change
    add_column :invoicing_ledger_items, :plan_id, :integer
  end
end
