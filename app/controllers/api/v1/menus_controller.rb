class Api::V1::MenusController < ApplicationController
  def index
    render json: Menu.all
  end

  def show
    render json: Menu.find(params[:id])
  end
end
