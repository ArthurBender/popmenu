require 'rails_helper'

RSpec.describe Menu, type: :model do
  before do
    @restaurant = create(:restaurant)
  end

  describe "fields" do
    it "should create a menu" do
      menu = build(:menu, restaurant: @restaurant)

      expect { menu.save! }.to change { Menu.count }.by(1)

      expect(menu).to be_valid
    end

    it "should not create a menu without a name" do
      menu = build(:menu, restaurant: @restaurant, name: nil)

      expect { menu.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "associations" do
    it "should have many menu items" do
      menu = create(:menu, restaurant: @restaurant)

      expect(menu).to respond_to(:menu_items)
    end

    it "should not destroy menu items when destroyed" do
      menu = create(:menu, restaurant: @restaurant)
      create(:menu_item, menus: [ menu ])

      expect { menu.destroy }.to change { MenuItem.count }.by(0)
    end

    it "should destroy menu entries when destroyed" do
      menu = create(:menu, restaurant: @restaurant)
      create(:menu_item, menus: [ menu ])

      expect { menu.destroy }.to change { MenuEntry.count }.by(-1)
    end
  end
end
