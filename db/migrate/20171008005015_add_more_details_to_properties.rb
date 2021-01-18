class AddMoreDetailsToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :property_category, :string
    add_column :properties, :number_unit, :integer
    add_column :properties, :year_built, :integer
    add_column :properties, :parking, :string
    add_column :properties, :lot_size, :string
    add_column :properties, :zoning, :string
    add_column :properties, :PropertyListing_id, :integer
  end
end
