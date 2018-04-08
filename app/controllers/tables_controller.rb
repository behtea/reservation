class TablesController < ApplicationController
  before_action :set_restaurant

  def index
    tables = @restaurant.tables
    json_response(tables)    
  end

  def show
    table = @restaurant.tables.find(params[:id])
    json_response(table)    
  end  

  def create
    table = @restaurant.tables.create!(table_params)
    json_response(table, :created)
  end  

  private
  
  def table_params
    params.permit(:restaurant_id, :name, :minimum_guest, :maximum_guest)
  end  

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
