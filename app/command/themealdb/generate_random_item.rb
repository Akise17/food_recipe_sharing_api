module Themealdb
    class GenerateRandomItem
        include HTTParty
        require 'uri'
        require 'net/http'
    
        base_uri Rails.application.config_for(:themealdb)["base_url"]
        API_KEY = Rails.application.config_for(:themealdb)["apikey"]
    
        def self.run
            response = generate 

            recipes = []
            
            begin
                response["meals"].each do |meal|
                    result = Hash.new
                    result["name"] = meal["strMeal"]
                    result["category"] = meal["strCategory"]
                    result["subcategory"] = meal["strTags"]
                    result["national"] = meal["strArea"]
                    result["ingredients"] = []
                    result["instructions"] = []

                    20.times { |i|
                        if meal["strMeasure#{i+1}"] != " "
                            ingredient = {
                                ingredient: meal["strIngredient#{i+1}"],
                                measure: meal["strMeasure#{i+1}"]
                            }
                            result["ingredients"].push(ingredient)
                        end
                    }

                    instructions = meal["strInstructions"].split("\r\n")
                    instructions.each do |instruction|
                        result["instructions"].push(
                            {
                                instruction: instruction
                            }
                        )
                    end

                    recipes.push(result)
                end
            rescue => exception
                puts "Error"
                puts exception.as_json    
            end
            
            return recipes
        end
    
        private
        def self.generate
            get(
                "/#{API_KEY}/random.php", 
            )
        end
    end
end