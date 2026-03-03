require 'rails_helper'

RSpec.describe "Api::V1::MenuItems", type: :request do
  before do
    @menu = create(:menu)
    @menu_item = create(:menu_item, menu: @menu)
  end

  describe "index" do
    it "returns a list of menu items" do
      get api_v1_menu_menu_items_path(menu_id: @menu.id)

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).length).to eq(1)
    end
  end

  describe "show" do
    it "returns a single menu item" do
      get api_v1_menu_menu_item_path(menu_id: @menu.id, id: @menu_item.id)

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["name"]).to eq(@menu_item.name)
      expect(JSON.parse(response.body)["price"]).to eq(@menu_item.price)
    end

    it "returns a 404 if the menu item does not exist" do
      get api_v1_menu_menu_item_path(menu_id: @menu.id, id: 0)

      expect(response).to have_http_status(404)
    end

    it "doesn't return items from other menus" do
      other_menu = create(:menu)

      get api_v1_menu_menu_item_path(menu_id: other_menu.id, id: @menu_item.id)

      expect(response).to have_http_status(404)
    end
  end
end
