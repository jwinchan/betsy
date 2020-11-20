class Removeorderstatusfromorders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :order_status, :string
  end
end
