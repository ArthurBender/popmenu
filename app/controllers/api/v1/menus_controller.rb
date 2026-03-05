class Api::V1::MenusController < ApplicationController
  def index
    restaurant = Restaurant.where(id: params[:restaurant_id]).includes(:menus)
    raise ActiveRecord::RecordNotFound if restaurant.empty?

    @menus = restaurant.first.menus
  end

  def show
    @menu = Menu.includes(:menu_entries, :menu_items).find_by(id: params[:id], restaurant_id: params[:restaurant_id])
    raise ActiveRecord::RecordNotFound if @menu.nil?
  end
end
