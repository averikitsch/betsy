class AddDefaultValueTrueToActiveProducts < ActiveRecord::Migration[5.1]
  def change
    change_column :products, :active, :boolean, default: true
  end
end
