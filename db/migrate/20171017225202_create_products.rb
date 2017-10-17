class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.integer :stock
      t.text :description
      t.string :image
      t.boolean :active

      t.timestamps
    end
  end
end
