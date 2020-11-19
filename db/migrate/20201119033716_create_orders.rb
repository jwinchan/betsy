class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.integer :order_item_id
      t.string :name
      t.string :email
      t.string :mailing_address
      t.string :cc_name
      t.bigint :cc_number
      t.string :cc_exp_date
      t.integer :billing_zip_code

      t.timestamps
    end
  end
end
