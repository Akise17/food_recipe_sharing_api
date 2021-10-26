module Themealdb
    class SearchByName
        include HTTParty
        require 'uri'
        require 'net/http'
    
        base_uri Rails.application.config_for(:themealdb)["base_url"]
        API_KEY = Rails.application.config_for(:themealdb)["apikey"]
    
        def self.run(keyword)
            response = search(keyword)
            
            recipes = []
            
            begin
                response["meals"].each do |meal|
                    result = Hash.new
                    result["name"] = meal["strMeal"]
                    result["category"] = meal["strCategory"]
                    result["subcategory"] = meal["strTags"]
                    result["national"] = meal["strArea"]
                    result["ingredient"] = []

                    20.times { |i|
                        if meal["strMeasure#{i+1}"] != " "
                            result["ingredient"].push(meal["strMeasure#{i+1}"] + " " + meal["strIngredient#{i+1}"])
                        end
                    }

                    instruction = meal["strInstructions"].split("\r\n")
                    result["instruction"] = instruction

                    recipes.push(result)
                end
            rescue => exception
                puts "Error"
                puts exception.as_json    
            end
            
            return recipes
        end
    
        private
        def self.search(keyword)
            get(
                "/#{API_KEY}/search.php?s=#{keyword}", 
            )
        end
    end
end