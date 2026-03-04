class ChangeItemPriceToEntry < ActiveRecord::Migration[8.1]
  def change
    MenuEntry.destroy_all

    remove_column :menu_items, :price
    add_column :menu_entries, :price, :float, null: false
  end
end
