class AddCancelledToOrderProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :order_products, :cancelled, :boolean, default: false
  end
end
