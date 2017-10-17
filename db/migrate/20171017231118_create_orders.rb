class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :email
      t.string :address
      t.string :name
      t.string :cc_num
      t.string :cc_expiry
      t.string :cc_cvv
      t.string :billing_zip

      t.timestamps
    end
  end
end
