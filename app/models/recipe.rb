class Recipe < ApplicationRecord
    has_many :ingredients, class_name: "Ingredient", foreign_key: "recipe_id", :dependent => :destroy 
    has_many :instructions, class_name: "Instruction", foreign_key: "recipe_id", :dependent => :destroy 

    acts_as_paranoid

    accepts_nested_attributes_for :ingredients, :allow_destroy => true
    accepts_nested_attributes_for :instructions, :allow_destroy => true
end
