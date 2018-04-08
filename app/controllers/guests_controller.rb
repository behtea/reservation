class GuestsController < ApplicationController
  def index
    guests = Guest.all
    json_response(guests)    
  end

  def show
    guest = Guest.find(params[:id])
    json_response(guest)    
  end  

  def create
    guest = Guest.create!(guest_params)
    json_response(guest, :created)
  end  

  private
  
  def guest_params
    params.permit(:name, :email)
  end  
end
