require 'rails_helper'

RSpec.describe "Api::V1::Imports", type: :request do
  describe "create" do
    it "returns a 201 for a valid schema" do
      post api_v1_imports_path, params: { file: fixture_file_upload("imports_valid.json", "application/json") }

      expect(response).to have_http_status(201)
      body = JSON.parse(response.body)

      expect(body.dig("resources_created", "logs")).to be_an(Array)
      expect(body.dig("resources_created", "logs")&.size).to eq(8)
      expect(body.dig("resources_created", "totals")).to eq({
        "restaurants" => 2,
        "menus" => 4,
        "menu_items" => 6,
        "menu_entries" => 7,
        "errors" => 1
      })
    end

    it "returns a 400 for an invalid schema" do
      post api_v1_imports_path, params: { file: fixture_file_upload("imports_invalid.json", "application/json") }

      expect(response).to have_http_status(422)
    end

    it "returns a 400 when no file is provided" do
      post api_v1_imports_path

      expect(response).to have_http_status(400)
    end
  end
end
