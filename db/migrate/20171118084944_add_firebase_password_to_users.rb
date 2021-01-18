class AddFirebasePasswordToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :firebase_password, :string
  end
end
