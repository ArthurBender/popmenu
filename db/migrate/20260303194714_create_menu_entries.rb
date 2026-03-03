class CreateMenuEntries < ActiveRecord::Migration[8.1]
  def change
    Menu.destroy_all

    create_table :menu_entries do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :menu_item, null: false, foreign_key: true

      t.timestamps
    end

    remove_column :menu_items, :menu_id
    add_reference :menus, :restaurant, null: false, foreign_key: true
  end
end
