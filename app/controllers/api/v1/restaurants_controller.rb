class Api::V1::RestaurantsController < ApplicationController
  def index
    render json: Restaurant.all
  end

  def show
    render json: Restaurant.find(params[:id])
  end
end
