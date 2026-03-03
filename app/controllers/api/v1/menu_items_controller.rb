class Api::V1::MenuItemsController < ApplicationController
  def index
    render json: MenuItem.all
  end

  def show
    render json: MenuItem.find(params[:id])
  end
end
