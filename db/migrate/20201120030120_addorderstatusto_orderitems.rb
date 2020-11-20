class AddorderstatustoOrderitems < ActiveRecord::Migration[6.0]
  def change
    add_column :orderitems, :order_status, :string, default: "pending"
  end
end
