require 'rails_helper'

RSpec.describe "Api::V1::Menus", type: :request do
  before do
    @menu = create(:menu)
  end

  describe "index" do
    it "returns a list of menus" do
      get api_v1_menus_path

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).length).to eq(1)
    end
  end

  describe "show" do
    it "returns a single menu" do
      get api_v1_menu_path(@menu)

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["name"]).to eq(@menu.name)
    end

    it "returns a 404 if the menu does not exist" do
      get api_v1_menu_path(0)

      expect(response).to have_http_status(404)
    end
  end
end
