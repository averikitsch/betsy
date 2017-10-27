class ChangeDefaultImage < ActiveRecord::Migration[5.1]
  def change
    change_column_default :products, :image, "placeholder.jpg"
  end
end
