class AddLastScheduledInvoiceAtToMembers < ActiveRecord::Migration
  def change
    add_column :members, :last_scheduled_invoice_at, :datetime
  end
end
