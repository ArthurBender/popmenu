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
      expect(result["success"]).to eq(true)
      expect(result["logs"]).to be_an(Array)
      expect(result["logs"].size).to eq(8)
    end

    it "is idempotent when importing the same file twice" do
      first_file = File.open(Rails.root.join("spec/fixtures/files/imports_valid.json"))
      second_file = File.open(Rails.root.join("spec/fixtures/files/imports_valid.json"))

      first_result = described_class.call(first_file)
      second_result = nil

      expect {
        second_result = described_class.call(second_file)
      }.to change(Restaurant, :count).by(0)
        .and change(Menu, :count).by(0)
        .and change(MenuItem, :count).by(0)
        .and change(MenuEntry, :count).by(0)

      expect(first_result["totals"]).to eq({
        "restaurants" => 2,
        "menus" => 4,
        "menu_items" => 7,
        "menu_entries" => 8,
        "errors" => 0
      })
      expect(second_result["totals"]).to eq({
        "restaurants" => 0,
        "menus" => 0,
        "menu_items" => 0,
        "menu_entries" => 0,
        "errors" => 0
      })
      expect(second_result["success"]).to eq(true)
      expect(second_result["logs"].size).to eq(8)
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
