class AddRehabCostToProperty < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :rehab_cost, :int
  end
end
