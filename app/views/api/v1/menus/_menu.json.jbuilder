json.extract! menu, :id, :name, :created_at, :updated_at

if local_assigns[:include_items]
  json.menu_items menu.menu_entries do |menu_entry|
    json.partial! "api/v1/menu_items/menu_item", menu_entry: menu_entry
  end
end
