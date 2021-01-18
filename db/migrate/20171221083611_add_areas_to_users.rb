class AddAreasToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :areas, :text, default: ''
  end
end
