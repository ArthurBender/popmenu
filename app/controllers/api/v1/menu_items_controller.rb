class Api::V1::MenuItemsController < ApplicationController
  before_action :set_menu

  def index
    @menu_entries = @menu.menu_entries
  end

  def show
    @menu_entry = @menu.menu_entries.find_by(menu_item_id: params[:id])
    raise ActiveRecord::RecordNotFound if @menu_entry.nil?
  end

  private

  def set_menu
    menus = Menu.where(id: params[:menu_id], restaurant_id: params[:restaurant_id]).includes(:menu_entries, :menu_items)
    raise ActiveRecord::RecordNotFound if menus.empty?

    @menu = menus.first
  end
end
