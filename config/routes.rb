Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :menus, only: %i[index show]
      resources :menu_items, only: %i[index show]
    end
  end
end
