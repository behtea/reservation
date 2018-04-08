class RestaurantsController < ApplicationController
  def index
    restaurants = Restaurant.all
    json_response(restaurants)    
  end

  def show
    restaurant = Restaurant.find(params[:id])
    json_response(restaurant)    
  end  

  def create
    restaurant = Restaurant.create!(restaurant_params)
    json_response(restaurant, :created)
  end  

  private
  
  def restaurant_params
    params.permit(:name, :email, :phone)
  end  
end
