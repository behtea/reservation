class ReservationsController < ApplicationController
  before_action :set_restaurant

  def index
    reservations = @restaurant.reservations
    json_response(reservations.collect(&:json_formated))    
  end

  def show
    reservation = @restaurant.reservations.find(params[:id])
    json_response(reservation.json_formated)    
  end  

  def create
    reservation = @restaurant.reservations.create!(reservation_params)
    json_response(reservation, :created)
  end  

  def update
    reservation = @restaurant.reservations.find(params[:id])
    reservation.update(reservation_params)
    json_response(reservation, :updated)
  end    

  private
  
  def reservation_params
    params.permit(:id, :restaurant_id, :guest_id, :table_id, :guest_number, :booking_time)
  end  

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
