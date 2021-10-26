module Services
    class RecipeHandler
        def self.search_by_name(keyword)
            menu = Themealdb::SearchByName.run(keyword)
            Handler::Res.call(200, "Success Generate Item", menu)
        end

        def self.recommendation_item
            menu = Themealdb::GenerateRandomItem.run
            Handler::Res.call(200, "Success Generate Item", menu)
        end
        
        def self.create_recipe(recipe_params)
            puts recipe_params.as_json
            recipe = Recipe.new(recipe_params)

            if recipe.save
                Handler::Res.call(201, "Success to create recipe", 
                    recipe.as_json(:include => [:ingredients, :instructions])
                )
            else 
                Handler::Res.call(400, "Failed to create recipe", recipe)
            end
        end

        def self.show_all_recipe(params)
            q = Recipe.all.ransack(params[:q])
            
            recipe = q.result.paginate(:page => params[:page], :per_page => params[:per_page] || 10)

            res = {
                total: q.result.count,
                current_page:recipe.current_page, 
                total_pages:(q.result.count/10)+1, 
                limit:recipe.per_page,
                recipes: recipe.as_json(:include => [:ingredients, :instructions])
                }
            
            if recipe
                Handler::Res.call(200, "Success to show all", res)
            else 
                Handler::Res.call(422, "Failed to show all", recipe)
            end
        end

        def self.show_recipe_by_id(params)
            recipe = Recipe.find(params[:id])

            if recipe
                Handler::Res.call(200, "Success to show all", 
                    recipe.as_json(:include => [:ingredients, :instructions])
                )
            else 
                Handler::Res.call(422, "Failed to show all", recipe)
            end
        end

        def self.update_recipe(id, recipe_params)
            recipe = Recipe.find(id)

            if recipe.update_attributes(recipe_params)
                Handler::Res.call(200, "Success to create recipe", 
                    recipe.as_json(:include => [:ingredients, :instructions])
                )
            else
                Handler::Res.call(422, "Failed to update recipe", recipe)
            end
        end
        
        def self.destroy_recipe(id)
            begin
                recipe = Recipe.find(id)

                if recipe.destroy
                    Handler::Res.call(200, "Deletion Success", 
                        recipe.as_json(:include => [:ingredients, :instructions])
                    )
                else
                    Handler::Res.call(422, "Deletion Failed", recipe)
                end
            rescue => exception
                Handler::Res.call(404, "Recipe not found", recipe)
            end
            
        end
        
    end
end