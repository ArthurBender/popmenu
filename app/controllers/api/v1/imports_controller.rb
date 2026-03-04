class Api::V1::ImportsController < ApplicationController
  rescue_from JSON::Schema::ValidationError, with: :render_unprocessable
  rescue_from JSON::ParserError, with: :render_unprocessable

  def create
    result = ImportRestaurantDataService.call(params.require(:file))

    render json: { resources_created: result }, status: :created
  end

  private

  def render_unprocessable(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end
