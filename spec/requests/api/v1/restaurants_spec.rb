require 'rails_helper'

RSpec.describe "Api::V1::Restaurants", type: :request do
  before do
    @restaurant = create(:restaurant)
    @menu = create(:menu, restaurant: @restaurant, name: "Lunch")
  end

  describe "index" do
    it "returns a list of restaurants" do
      get api_v1_restaurants_path

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).length).to eq(1)
    end
  end

  describe "show" do
    it "returns a single restaurant" do
      get api_v1_restaurant_path(@restaurant)

      expect(response).to have_http_status(200)
      body = JSON.parse(response.body)

      expect(body["id"]).to eq(@restaurant.id)
      expect(body["name"]).to eq(@restaurant.name)
      expect(body["menus"]).to be_an(Array)
      expect(body["menus"].size).to eq(1)

      first_menu = body["menus"].first
      expect(first_menu.keys).to contain_exactly("id", "name", "created_at", "updated_at")
      expect(first_menu["id"]).to eq(@menu.id)
      expect(first_menu["name"]).to eq(@menu.name)
    end

    it "returns a 404 if the restaurant does not exist" do
      get api_v1_restaurant_path(0)

      expect(response).to have_http_status(404)
    end
  end
end
