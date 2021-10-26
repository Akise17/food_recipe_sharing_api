class Api::V1::RecipeController < Api::ApplicationController
    def search_by_name
       menu = Services::RecipeHandler.search_by_name(params[:keyword])
       render json: menu.as_json, status: menu[:meta][:status]
    end

    def recomendation_item
        menu = Services::RecipeHandler.recomendation_item
        render json: menu.as_json, status: menu[:meta][:status]
    end

    def create_recipe
        recipe = Services::RecipeHandler.create_recipe(recipe_params)
        render json: recipe.as_json, status: recipe[:meta][:status]
    end
    
    def show_all_recipe
        recipe = Services::RecipeHandler.show_all_recipe(params)
        render json: recipe.as_json, status: recipe[:meta][:status]
    end

    def show_recipe_by_id
        recipe = Services::RecipeHandler.show_recipe_by_id(params)
        render json: recipe.as_json, status: recipe[:meta][:status]
    end

    def update_recipe
        recipe = Services::RecipeHandler.update_recipe(params[:id], recipe_params)
        render json: recipe.as_json, status: recipe[:meta][:status]
    end
    
    def destroy_recipe
        recipe = Services::RecipeHandler.destroy_recipe(params[:id])
        render json: recipe.as_json, status: recipe[:meta][:status]
    end

    private

    def recipe_params
        params.require(:recipe).permit(
            :name, :category, :subcategory, :national,
            ingredients_attributes: [:id, :recipe_id, :ingredient, :measure],
            instructions_attributes: [:id, :recipe_id, :instruction]
        )
    end
    
end
