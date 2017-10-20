class AddOauthFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :uid, :integer, null: false
    add_column :users, :provider, :string, null: false
  end
end
