class MenuEntry < ApplicationRecord
  belongs_to :menu
  belongs_to :menu_item

  validate :menu_restaurant_matches

  private

  def menu_restaurant_matches
    existing_entries_for_item = MenuEntry.where(menu_item_id: menu_item_id)

    return if existing_entries_for_item.empty?

    existing_restaurant_ids = existing_entries_for_item.map(&:menu).map(&:restaurant_id)

    return if existing_restaurant_ids.include?(menu.restaurant_id)

    errors.add(:menu_item, "must belong only to menus from the same restaurant")
  end
end
