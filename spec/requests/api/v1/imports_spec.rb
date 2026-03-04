require 'rails_helper'

RSpec.describe "Api::V1::Imports", type: :request do
  describe "create" do
    it "returns a 201 for a valid schema" do
      post api_v1_imports_path, params: { file: fixture_file_upload("imports_valid.json", "application/json") }

      expect(response).to have_http_status(201)
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
