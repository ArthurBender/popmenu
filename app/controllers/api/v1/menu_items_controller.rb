class Api::V1::MenuItemsController < ApplicationController
  before_action :set_menu

  def index
    render json: @menu.menu_items
  end

  def show
    render json: @menu.menu_items.find(params[:id])
  end

  def set_menu
    menus = Menu.where(id: params[:menu_id], restaurant_id: params[:restaurant_id]).includes(:menu_items)
    raise ActiveRecord::RecordNotFound if menus.empty?

    @menu = menus.first
  end
end
