class AddDefaultValues < ActiveRecord::Migration[5.1]
  def change
    change_column :order_products, :shipped, :boolean, default: false
    change_column_default :orders, :status, "pending"
    change_column_default :products, :image, "http://placebeyonce.com/200-300"
  end
end
