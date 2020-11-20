class Addshippedtoorderitems < ActiveRecord::Migration[6.0]
  def change
    add_column :orderitems, :shipped, :boolean, default: false
  end
end
