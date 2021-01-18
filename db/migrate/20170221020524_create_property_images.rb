class CreatePropertyImages < ActiveRecord::Migration[5.0]
  def change
    create_table :property_images do |t|
      t.string :image_url
      t.references :property, foreign_key: true

      t.timestamps
    end
  end
end
