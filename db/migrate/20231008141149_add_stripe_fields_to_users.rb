class AddStripeFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :stripe_customer_id, :text
    add_column :users, :last_checkout_reference, :text
    add_column :users, :subscription_status, :text
  end
end
