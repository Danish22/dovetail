class AddPaymentGatewaysToMembers < ActiveRecord::Migration
  def change
    add_column :members, :payment_system_customer_id, :string
    add_column :members, :last_4_digits, :string
  end
end
