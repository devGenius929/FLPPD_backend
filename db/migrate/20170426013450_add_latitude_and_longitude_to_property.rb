class AddLatitudeAndLongitudeToProperty < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :latitude, :float
    add_column :properties, :longitude, :float
  end
end
