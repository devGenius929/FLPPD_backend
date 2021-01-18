class AddPassResetToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :password_reset_token, :string
    add_column :users, :password_reset_sent_at, :datetime
    add_column :users, :pin, :string
    add_column :users, :verified, :boolean, default: false
  end
end
