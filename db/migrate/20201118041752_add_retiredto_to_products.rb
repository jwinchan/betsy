class AddRetiredtoToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :retired, :boolean, default: false
  end
end
