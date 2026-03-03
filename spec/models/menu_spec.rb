require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe "fields" do
    it "should create a menu" do
      menu = build(:menu)

      expect { menu.save! }.to change { Menu.count }.by(1)

      expect(menu).to be_valid
    end

    it "should not create a menu without a name" do
      menu = build(:menu, name: nil)

      expect { menu.save! }.to raise_error(ActiveRecord::NotNullViolation)
    end
  end

  describe "associations" do
    it "should have many menu items" do
      menu = create(:menu)

      expect(menu).to respond_to(:menu_items)
    end

    it "should destroy menu items when destroyed" do
      menu = create(:menu)
      create(:menu_item, menu: menu)

      expect { menu.destroy }.to change { MenuItem.count }.by(-1)
    end
  end
end
