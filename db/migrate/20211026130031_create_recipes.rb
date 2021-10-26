class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :category
      t.string :subcategory
      t.string :national
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
