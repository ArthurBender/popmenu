class Api::V1::MenuItemsController < ApplicationController
  before_action :set_menu

  def index
    render json: @menu.menu_entries, methods: :name
  end

  def show
    item = @menu.menu_entries.find_by(menu_item_id: params[:id])
    raise ActiveRecord::RecordNotFound if item.nil?

    render json: item, methods: :name
  end

  private

  def set_menu
    menus = Menu.where(id: params[:menu_id], restaurant_id: params[:restaurant_id]).includes(:menu_items)
    raise ActiveRecord::RecordNotFound if menus.empty?

    @menu = menus.first
  end
end
