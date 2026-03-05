require "rails_helper"

RSpec.describe ImportRestaurantDataService do
  describe ".call" do
    it "returns the created resources with a valid file" do
      file = File.open(Rails.root.join("spec/fixtures/files/imports_valid.json"))

      result = nil

      expect {
        result = described_class.call(file)
      }.to change(Restaurant, :count).by(2)
        .and change(Menu, :count).by(4)
        .and change(MenuItem, :count).by(7)
        .and change(MenuEntry, :count).by(8)

      expect(result["totals"]).to eq({
        "restaurants" => 2,
        "menus" => 4,
        "menu_items" => 7,
        "menu_entries" => 8,
        "errors" => 0
      })
      expect(result["logs"]).to be_an(Array)
      expect(result["logs"].size).to eq(8)
    end

    it "raises for the invalid file" do
      file = File.open(Rails.root.join("spec/fixtures/files/imports_invalid.json"))

      expect { described_class.call(file) }.to raise_error(JSON::Schema::ValidationError)

      expect(Restaurant.count).to eq(0)
      expect(Menu.count).to eq(0)
      expect(MenuItem.count).to eq(0)
      expect(MenuEntry.count).to eq(0)
    end
  end
end
