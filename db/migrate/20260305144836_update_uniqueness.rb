class UpdateUniqueness < ActiveRecord::Migration[8.1]
  def change
    MenuItem.destroy_all

    add_reference :menu_items, :restaurant, null: false, foreign_key: true

    add_index :restaurants, :name, unique: true
    add_index :menus, [ :restaurant_id, :name ], unique: true
    add_index :menu_entries, [ :menu_id, :menu_item_id ], unique: true
    add_index :menu_items, [ :restaurant_id, :name ], unique: true

    change_column :menu_entries, :price, :decimal, null: false
  end
end
