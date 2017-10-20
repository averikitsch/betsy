class AddNicknameAndDateToReview < ActiveRecord::Migration[5.1]
  def change
    add_column :reviews, :nickname, :string
    add_column :reviews, :location, :string
  end
end
