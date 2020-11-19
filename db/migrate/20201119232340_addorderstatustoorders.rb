class Addorderstatustoorders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :order_status, :string, default: "pending"
  end
end
