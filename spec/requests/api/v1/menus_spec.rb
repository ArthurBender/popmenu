require 'rails_helper'

RSpec.describe "Api::V1::Menus", type: :request do
  before do
    @menu = create(:menu)
    @menu_entry = create(:menu_entry, menu: @menu, price: 12.5)
  end

  describe "index" do
    it "returns a list of menus" do
      get api_v1_restaurant_menus_path(restaurant_id: @menu.restaurant_id)

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).length).to eq(1)
    end

    it "returns a 404 if the restaurant does not exist" do
      get api_v1_restaurant_menus_path(restaurant_id: 0)

      expect(response).to have_http_status(404)
    end
  end

  describe "show" do
    it "returns a single menu" do
      get api_v1_restaurant_menu_path(restaurant_id: @menu.restaurant_id, id: @menu)

      expect(response).to have_http_status(200)
      body = JSON.parse(response.body)

      expect(body["id"]).to eq(@menu.id)
      expect(body["name"]).to eq(@menu.name)
      expect(body["menu_items"]).to be_an(Array)
      expect(body["menu_items"].size).to eq(1)

      first_item = body["menu_items"].first
      expect(first_item.keys).to contain_exactly("id", "name", "price", "created_at", "updated_at")
      expect(first_item["id"]).to eq(@menu_entry.menu_item_id)
      expect(first_item["name"]).to eq(@menu_entry.menu_item.name)
      expect(first_item["price"]).to eq(format("%.2f", @menu_entry.price))
    end

    it "returns a 404 if the menu does not exist" do
      get api_v1_restaurant_menu_path(restaurant_id: @menu.restaurant_id, id: 0)

      expect(response).to have_http_status(404)
    end

    it "returns a 404 if the restaurant does not exist" do
      get api_v1_restaurant_menu_path(restaurant_id: 0, id: @menu)

      expect(response).to have_http_status(404)
    end

    it "does not return menus from other restaurants" do
      other_restaurant = create(:restaurant)

      get api_v1_restaurant_menu_path(restaurant_id: other_restaurant.id, id: @menu)

      expect(response).to have_http_status(404)
    end
  end
end
