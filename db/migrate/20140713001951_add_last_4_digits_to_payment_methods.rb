class AddLast4DigitsToPaymentMethods < ActiveRecord::Migration
  def change
    add_column :payment_methods, :last_4_digits, :string
  end
end
