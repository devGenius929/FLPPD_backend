class AddFavoritesToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :favorites, :integer, array: true, default: []
  end
end
