Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do 
    namespace :v1 do
      post  "/signup", to: "authentication#signup"
      post  "/verify", to: "authentication#verify_email"

      get   "/recipe/search", to: "recipe#search_by_name"
      get   "/recipe/recomendation", to: "recipe#search_by_name"
    end
  end
end
