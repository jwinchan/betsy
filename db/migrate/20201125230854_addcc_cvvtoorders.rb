class AddccCvvtoorders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :cc_cvv, :integer
  end
end
