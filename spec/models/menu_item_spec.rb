require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe "fields" do
    it "should create a menu item" do
      menu_item = build(:menu_item)

      expect { menu_item.save! }.to change { MenuItem.count }.by(1)

      expect(menu_item).to be_valid
    end

    it "should not create a menu item without a name" do
      menu_item = build(:menu_item, name: nil)

      expect { menu_item.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should not allow duplicated names for same restaurant" do
      menu_item = create(:menu_item, name: "Item 1")

      expect { create(:menu_item, name: "Item 1", restaurant: menu_item.restaurant) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "associations" do
    it "should have many menus" do
      menu_item = create(:menu_item)

      expect(menu_item).to respond_to(:menus)
    end

    it "should be able to belong to many menus" do
      menu_entry = create(:menu_entry)
      other_entry = create(:menu_entry, menu: create(:menu, restaurant: menu_entry.menu.restaurant), menu_item: menu_entry.menu_item)

      expect(menu_entry.menu_item.menus).to include(menu_entry.menu, other_entry.menu)
    end

    it "should not destroy menu when destroyed" do
      menu_item = create(:menu_item)

      expect { menu_item.destroy }.to change { Menu.count }.by(0)
    end

    it "should destroy menu entries when destroyed" do
      menu_entry = create(:menu_entry)

      expect { menu_entry.menu_item.destroy }.to change { MenuEntry.count }.by(-1)
    end
  end
end
