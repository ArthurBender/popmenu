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

      expect { menu.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "associations" do
    before do
      @menu = create(:menu)
    end

    it "should have many menu items" do
      expect(@menu).to respond_to(:menu_items)
    end

    it "should not destroy menu items when destroyed" do
      create(:menu_item, menus: [ @menu ])

      expect { @menu.destroy }.to change { MenuItem.count }.by(0)
    end

    it "should destroy menu entries when destroyed" do
      create(:menu_item, menus: [ @menu ])

      expect { @menu.destroy }.to change { MenuEntry.count }.by(-1)
    end
  end
end
