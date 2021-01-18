class CreateNetworks < ActiveRecord::Migration[5.0]
  def change
    create_table :networks do |t|
      t.integer :user_id
      t.integer :friend_id
      t.boolean :status

      t.timestamps
    end
  end
end
