class AddRankAndHausesSoldToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :rank, :text, default: 'Average'
    add_column :users, :hauses_sold, :integer, default: 0
  end
end
