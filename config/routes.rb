Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do 
    namespace :v1 do
      post  "/signup", to: "authentication#signup"
      post  "/verify", to: "authentication#verify_email"

      get   "/recipe/search", to: "recipe#search_by_name"
      get   "/recipe/recomendation", to: "recipe#search_by_name"
      post  "/recipe/create", to: "recipe#create_recipe"
      put  "/recipe/update/:id", to: "recipe#update_recipe"
      delete  "/recipe/destroy/:id", to: "recipe#destroy_recipe"
      get  "/recipe/show/all", to: "recipe#show_all_recipe"
      get  "/recipe/show/:id", to: "recipe#show_recipe_by_id"
    end
  end
end
