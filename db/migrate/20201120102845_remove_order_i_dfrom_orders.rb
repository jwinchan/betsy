class RemoveOrderIDfromOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :order_item_id
  end
end
