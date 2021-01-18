class CreateProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :properties do |t|
      t.integer :price
      t.integer :arv
      t.string :street
      t.string :city
      t.string :state
      t.integer :zip_code
      t.string :nbeds
      t.string :nbath
      t.text :description
      t.integer :sqft
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
