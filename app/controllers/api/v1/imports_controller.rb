class Api::V1::ImportsController < ApplicationController
  def create
    result = ImportRestaurantDataService.call(params.require(:file))

    render json: { resources_created: result }, status: :created
  end
end
