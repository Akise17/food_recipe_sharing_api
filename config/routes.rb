Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do 
    namespace :v1 do
      post  "/signup", to: "authentication#signup"
      post  "/verify", to: "authentication#verify_email"
    end
  end
end
