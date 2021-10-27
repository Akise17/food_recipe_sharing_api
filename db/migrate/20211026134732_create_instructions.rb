class CreateInstructions < ActiveRecord::Migration[5.2]
  def change
    create_table :instructions do |t|
      t.integer :recipe_id
      t.text :instruction
      t.timestamps
    end
  end
end
