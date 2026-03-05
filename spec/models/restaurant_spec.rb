require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe "fields" do
    it "should create a restaurant" do
      restaurant = build(:restaurant)

      expect { restaurant.save! }.to change { Restaurant.count }.by(1)

      expect(restaurant).to be_valid
    end

    it "should not create a restaurant without a name" do
      restaurant = build(:restaurant, name: nil)

      expect { restaurant.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should not allow duplicated names" do
      create(:restaurant, name: "Restaurant 1")

      expect { create(:restaurant, name: "Restaurant 1") }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "associations" do
    it "should have many menus" do
      restaurant = create(:restaurant)

      expect(restaurant).to respond_to(:menus)
    end

    it "should have many menu items" do
      restaurant = create(:restaurant)

      expect(restaurant).to respond_to(:menu_items)
    end

    it "should destroy menus when destroyed" do
      restaurant = create(:restaurant)
      create(:menu, restaurant: restaurant)

      expect { restaurant.destroy }.to change { Menu.count }.by(-1)
    end

    it "should destroy menu items when destroyed" do
      restaurant = create(:restaurant)
      create(:menu_item, restaurant: restaurant)

      expect { restaurant.destroy }.to change { MenuItem.count }.by(-1)
    end
  end
end
