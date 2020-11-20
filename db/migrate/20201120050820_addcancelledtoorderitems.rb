class Addcancelledtoorderitems < ActiveRecord::Migration[6.0]
  def change
    add_column :orderitems, :cancelled, :boolean, default: false
  end
end
