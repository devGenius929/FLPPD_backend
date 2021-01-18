class CreatePropertylistings < ActiveRecord::Migration[5.0]
  def change
    create_table :propertylistings do |t|
      t.string :pl_name

      t.timestamps
    end
  end
end
