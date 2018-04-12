class ReservationMailer < ApplicationMailer

  def send_detail_reservation(reservation)
    @reservation = reservation
    mail(to: @reservation.guest.email, subject: 'Your Reservation')
  end  

  def send_new_reservation(reservation)
    @reservation = reservation
    mail(to: @reservation.restaurant.email, subject: 'New Reservation')
  end    

  def send_update_detail_reservation(reservation)
    @reservation = reservation
    @old_reservation = reservation.changes

    @old_table_name = @reservation.table.name
    unless @old_reservation["table_id"].blank?
      @old_table_name = Table.find(@old_reservation["table_id"].first).name
    end  
    
    @old_guest_number = @reservation.guest_number 
    unless @old_reservation["guest_number"].blank?
      @old_guest_number = @old_reservation["guest_number"].first
    end          

    @old_booking_time = @reservation.booking_time
    unless @old_reservation["booking_time"].blank?
      @old_booking_time = @old_reservation["booking_time"].first
    end
    
    mail(to: @reservation.guest.email, subject: 'Your Reservation Update')
  end    
end
