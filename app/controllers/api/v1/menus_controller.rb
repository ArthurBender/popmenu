class Api::V1::MenusController < ApplicationController
  def index
    restaurant = Restaurant.where(id: params[:restaurant_id]).includes(:menus)
    raise ActiveRecord::RecordNotFound if restaurant.empty?

    render json: restaurant.first.menus
  end

  def show
    menu = Menu.where(id: params[:id], restaurant_id: params[:restaurant_id])
    raise ActiveRecord::RecordNotFound if menu.empty?

    render json: menu.first
  end
end
