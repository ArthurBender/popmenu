class Api::V1::RestaurantsController < ApplicationController
  def index
    @restaurants = Restaurant.all
  end

  def show
    @restaurant = Restaurant.includes(:menus).find(params[:id])
  end
end
