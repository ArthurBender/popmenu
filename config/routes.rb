Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post "imports", to: "imports#create"

      resources :restaurants, only: %i[index show] do
        resources :menus, only: %i[index show] do
          resources :menu_items, only: %i[index show]
        end
      end
    end
  end
end
