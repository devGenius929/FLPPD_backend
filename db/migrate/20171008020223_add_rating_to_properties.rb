class AddRatingToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :rental_raiting, :integer
  end
end
