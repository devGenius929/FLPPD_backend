class AddImageToProperty < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :defaultimage, :string
  end
end
