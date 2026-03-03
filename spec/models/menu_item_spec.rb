require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  before do
    @menu = create(:menu)
  end

  describe "fields" do
    it "should create a menu item" do
      menu_item = build(:menu_item, menu: @menu)

      expect { menu_item.save! }.to change { MenuItem.count }.by(1)

      expect(menu_item).to be_valid
    end

    it "should not create a menu item without a name" do
      menu_item = build(:menu_item, name: nil, menu: @menu)

      expect { menu_item.save! }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "should not create a menu item without a price" do
      menu_item = build(:menu_item, price: nil, menu: @menu)

      expect { menu_item.save! }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "should not create a menu item without a menu" do
      menu_item = build(:menu_item, menu: nil)

      expect { menu_item.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "associations" do
    it "should belong to a menu" do
      menu_item = create(:menu_item, menu: @menu)

      expect(menu_item).to respond_to(:menu)
    end

    it "should not destroy menu when destroyed" do
      menu_item = create(:menu_item, menu: @menu)

      expect { menu_item.destroy }.to change { Menu.count }.by(0)
    end
  end
end
