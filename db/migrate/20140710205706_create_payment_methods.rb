class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.string :billing_name
      t.string :billing_email
      t.string :company_name
      t.string :stripe_id
      t.references :user, index: true

      t.timestamps
    end
  end
end
