class RemoveCategoryReferenceFromProducts < ActiveRecord::Migration[5.1]
  def change
    remove_reference :products, :category, index: true, foreign_key: true
  end
end
