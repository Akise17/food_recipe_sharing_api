module Services
    class Recipe
        def self.search_by_name(keyword)
            menu = Themealdb::SearchByName.run(keyword)
            Handler::Res.call(200, "Success Generate Item", menu)
        end

        def self.recommendation_item
            menu = Themealdb::GenerateRandomItem.run
            Handler::Res.call(200, "Success Generate Item", menu)
        end
        
    end
end