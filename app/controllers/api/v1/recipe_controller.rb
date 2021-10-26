class Api::V1::RecipeController < Api::ApplicationController
    def search_by_name
       menu = Services::Recipe.search_by_name(params[:keyword])
       render json: menu.as_json
    end

    def recomendation_item
        menu = Services::Recipe.recomendation_item
        render json: menu.as_json
    end
    
end
