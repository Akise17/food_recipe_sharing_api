class Api::V1::RecipeController < Api::ApplicationController
    before_action :authorize, :except => [
        :search_by_name, 
        :recomendation_item,
        :show_all_recipe,
        :show_recipe_by_id
    ]

    def search_by_name
       menu = Services::RecipeHandler.search_by_name(params[:keyword])
       render json: menu.as_json, status: menu[:meta][:status]
    end

    def recomendation_item
        menu = Services::RecipeHandler.recommendation_item
        render json: menu.as_json, status: menu[:meta][:status]
    end

    def create_recipe
        begin
            recipe = Services::RecipeHandler.create_recipe(recipe_params)
            render json: recipe.as_json, status: recipe[:meta][:status] 
        rescue => exception
            recipe = Handler::Res.call(400, "Failed to create recipe", recipe)
            render json: recipe.as_json, status: recipe[:meta][:status]
        end
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
        begin
            recipe = Services::RecipeHandler.update_recipe(params[:id], recipe_params)
            render json: recipe.as_json, status: recipe[:meta][:status]
        rescue => exception
            recipe = Handler::Res.call(400, "Failed to update recipe", recipe)
            render json: recipe.as_json, status: recipe[:meta][:status]
        end
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

    def authorize
        unless current_api_user.role == "contributor"
            auth = Handler::Res.call(401, "Unauthorized user for this method", current_api_user) 
            render json: auth.as_json, status: auth[:meta][:status] 
        end
    end
    
    
end
