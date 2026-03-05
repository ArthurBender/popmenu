json.extract! restaurant, :id, :name, :created_at, :updated_at

if local_assigns[:include_menus]
  json.menus restaurant.menus do |menu|
    json.partial! "api/v1/menus/menu", menu: menu
  end
end
