class AddPropertyTypeIdToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :PropertyType_id, :integer
  end
end
