class Api::V1::MenuItemsController < ApplicationController
  def index
    render json: Menu.find(params[:menu_id]).menu_items
  end

  def show
    render json: Menu.find(params[:menu_id]).menu_items.find(params[:id])
  end
end
