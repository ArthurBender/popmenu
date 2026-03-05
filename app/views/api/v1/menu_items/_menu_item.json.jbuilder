json.extract! menu_entry.menu_item, :id, :name
json.price format("%.2f", menu_entry.price)
json.extract! menu_entry.menu_item, :created_at, :updated_at
