class CreateIngredients < ActiveRecord::Migration[5.2]
  def change
    create_table :ingredients do |t|
      t.integer :recipe_id
      t.string :ingredient
      t.string :measure
      t.timestamps
    end
  end
end
