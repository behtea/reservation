class ShiftsController < ApplicationController
  before_action :set_restaurant

  def index
    shifts = @restaurant.shifts
    json_response(shifts)    
  end

  def show
    shift = @restaurant.shifts.find(params[:id])
    json_response(shift)    
  end  

  def create
    shift = @restaurant.shifts.create!(shift_params)
    json_response(shift, :created)
  end  

  private
  
  def shift_params
    params.permit(:restaurant_id, :name, :start_at, :end_at)
  end  

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
