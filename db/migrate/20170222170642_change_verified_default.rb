class ChangeVerifiedDefault < ActiveRecord::Migration[5.0]
  def up
    change_column :users, :verified, :boolean, default: false
  end

  def down
    change_column :users, :verified, :boolean, default: nil
  end
end
