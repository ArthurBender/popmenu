require 'rails_helper'

RSpec.describe MenuEntry, type: :model do
  describe "fields" do
    it "should create a menu entry" do
      menu_entry = build(:menu_entry)

      expect { menu_entry.save! }.to change { MenuEntry.count }.by(1)

      expect(menu_entry).to be_valid
    end

    it "should not create a menu entry without a price" do
      menu_entry = build(:menu_entry, price: nil)

      expect { menu_entry.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should not create a menu entry with negative price" do
      menu_entry = build(:menu_entry, price: -1)

      expect { menu_entry.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should not create a menu entry without a menu" do
      menu_entry = build(:menu_entry, menu: nil)

      expect { menu_entry.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should not create a menu entry without a menu item" do
      menu_entry = build(:menu_entry, menu_item: nil)

      expect { menu_entry.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should allow menu_item to belong to multiple menus" do
      menu_entry = create(:menu_entry)

      other_menu = create(:menu, restaurant: menu_entry.menu.restaurant)
      other_entry = build(:menu_entry, menu_item: menu_entry.menu_item, menu: other_menu)

      expect { other_entry.save! }.to change { MenuEntry.count }.by(1)

      expect(other_entry).to be_valid
    end

    it "should not allow menu_item to belong to menus from different restaurants" do
      menu_entry = create(:menu_entry)

      other_restaurant = create(:restaurant)
      other_menu = create(:menu, restaurant: other_restaurant)
      other_entry = build(:menu_entry, menu_item: menu_entry.menu_item, menu: other_menu)

      expect { other_entry.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should not allow menu_item to belong to the same menu" do
      menu_entry = create(:menu_entry)

      other_entry = build(:menu_entry, menu_item: menu_entry.menu_item, menu: menu_entry.menu)

      expect { other_entry.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "associations" do
    it "should belong to a menu" do
      menu_entry = create(:menu_entry)

      expect(menu_entry).to respond_to(:menu)
    end

    it "should belong to a menu item" do
      menu_entry = create(:menu_entry)

      expect(menu_entry).to respond_to(:menu_item)
    end
  end
end
