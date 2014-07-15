class AddStripeToSpaces < ActiveRecord::Migration
  def change
    add_column :spaces, :plan, :string
    add_column :spaces, :stripe_subscription_id, :string
    add_column :spaces, :payment_method_id, :integer
  end
end
