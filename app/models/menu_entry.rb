class MenuEntry < ApplicationRecord
  belongs_to :menu
  belongs_to :menu_item

  validates :menu_id, uniqueness: { scope: :menu_item_id }
  validates :price, numericality: { greater_than: 0 }
  validate :menu_restaurant_matches

  private

  def menu_restaurant_matches
    return if menu&.restaurant_id == menu_item&.restaurant_id

    errors.add(:menu_item, "must belong only to menus from the item restaurant")
  end
end
