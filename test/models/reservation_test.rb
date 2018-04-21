# == Schema Information
#
# Table name: reservations
#
#  id            :integer          not null, primary key
#  guest_id      :integer
#  restaurant_id :integer
#  table_id      :integer
#  guest_number  :integer
#  booking_time  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
  test "guest can reserve table" do
    guest = guests(:john)
    restaurant = restaurants(:restaurantone)
    table = tables(:restaurantonetableone)
    
    reservation = restaurant.reservations.create!({
      guest_id: guest.id,
      table_id: table.id,
      guest_number: 6,
      booking_time: "2018-04-16 09:00"
    })

    last_reservation = Reservation.last
    assert_equal guest, last_reservation.guest
    assert_equal restaurant, last_reservation.restaurant
    assert_equal table, last_reservation.table
    assert_equal 6, last_reservation.guest_number
    assert_equal "2018-04-16 09:00:00 UTC", last_reservation.booking_time.to_s

    # check email detail reservation
    detail_reservation_email = ActionMailer::Base.deliveries.first
    assert_equal "Your Reservation", detail_reservation_email.subject
    assert_equal 'john@doe.com', detail_reservation_email.to[0]
    assert_match(/Hi John Doe/, detail_reservation_email.body.to_s)    
    assert_match(/Restaurant: Restaurant One/, detail_reservation_email.body.to_s)  
    assert_match(/Table: Table One of Restaurant One/, detail_reservation_email.body.to_s)      
    assert_match(/Guest Number: 6/, detail_reservation_email.body.to_s)    
    assert_match(/Booking Time: 2018-04-16 09:00/, detail_reservation_email.body.to_s)     

    # check email new reservation
    new_reservation_email = ActionMailer::Base.deliveries.last
    assert_equal "New Reservation", new_reservation_email.subject
    assert_equal 'restro@one.com', new_reservation_email.to[0]
    assert_match(/There is new reservation, here is the details/, new_reservation_email.body.to_s)    
    assert_match(/Table: Table One of Restaurant One/, new_reservation_email.body.to_s)    
    assert_match(/Guest Number: 6/, new_reservation_email.body.to_s)    
    assert_match(/Booking Time: 2018-04-16 09:00/, new_reservation_email.body.to_s)  

  end

  test "guest can update reservation" do
    guest = guests(:jane)
    table = tables(:restaurantonetablethree)
    guest_number = 2
    
    reservation = reservations(:reservationsampletwo)
    reservation.update({
      table_id: table.id,
      guest_number: guest_number,
      booking_time: "2018-04-08 10:00:00",
    })

    reservation_reload = reservations(:reservationsampletwo)
    assert_equal table, reservation_reload.table
    assert_equal guest_number, reservation_reload.guest_number
    assert_equal "2018-04-08 10:00:00 UTC", reservation_reload.booking_time.to_s

    # check email update reservation
    update_reservation_email = ActionMailer::Base.deliveries.last
    assert_equal "Your Reservation Update", update_reservation_email.subject
    assert_equal 'jane@doe.com', update_reservation_email.to[0]
    
    # check old reservation
    assert_match(/Table: Table Two of Restaurant One/, update_reservation_email.body.to_s)    
    assert_match(/Guest Number: 3/, update_reservation_email.body.to_s)    
    assert_match(/Booking Time: 2018-04-08 20:00/, update_reservation_email.body.to_s)     

    # check new reservation
    assert_match(/Table: Table Three of Restaurant One/, update_reservation_email.body.to_s)    
    assert_match(/Guest Number: 2/, update_reservation_email.body.to_s)    
    assert_match(/Booking Time: 2018-04-08 10:00/, update_reservation_email.body.to_s)         
  end        

  test "guest can't reserve table because no available shift" do
    guest = guests(:john)
    restaurant = restaurants(:restaurantone)
    table = tables(:restaurantonetableone)
    
    reservation = restaurant.reservations.create({
      guest_id: guest.id,
      table_id: table.id,
      guest_number: 6,
      booking_time: "2018-04-16 13:00"
    })

    assert_equal "there is no available shift", reservation.errors.messages[:base].first
    assert_equal 2, Reservation.count
    
  end      

  test "guest can't reserve table because lack of guest number" do
    guest = guests(:jane)
    restaurant = restaurants(:restaurantone)
    table = tables(:restaurantonetableone)
    
    reservation = restaurant.reservations.create({
      guest_id: guest.id,
      table_id: table.id,
      guest_number: 2,
      booking_time: "2018-04-16 10:00"
    })

    assert_equal "guest number invalid", reservation.errors.messages[:base].first
    assert_equal 2, Reservation.count
  end  

  test "guest can't reserve table because excess of guest number" do
    guest = guests(:jane)
    restaurant = restaurants(:restaurantone)
    table = tables(:restaurantonetabletwo)
    
    reservation = restaurant.reservations.create({
      guest_id: guest.id,
      table_id: table.id,
      guest_number: 6,
      booking_time: "2018-04-16 10:00"
    })

    assert_equal "guest number invalid", reservation.errors.messages[:base].first
    assert_equal 2, Reservation.count
  end    

  test "guest can't reserve table because booking time table is same with other" do
    guest = guests(:jane)
    restaurant = restaurants(:restaurantone)
    table = tables(:restaurantonetableone)
    
    reservation = restaurant.reservations.create({
      guest_id: guest.id,
      table_id: table.id,
      guest_number: 2,
      booking_time: "2018-04-08 09:00:00"
    })

    assert_equal "table not available", reservation.errors.messages[:base].first
    assert_equal 2, Reservation.count
  end      

  test "guest can't reserve table because booking time table is overlap" do
    guest = guests(:jane)
    restaurant = restaurants(:restaurantone)
    table = tables(:restaurantonetableone)
    
    reservation = restaurant.reservations.create({
      guest_id: guest.id,
      table_id: table.id,
      guest_number: 2,
      booking_time: "2018-04-08 09:30:00"
    })

    assert_equal "table not available", reservation.errors.messages[:base].first
    assert_equal 2, Reservation.count
  end    

  test "guest can't update reservation because no shift" do
    guest = guests(:jane)
    table = tables(:restaurantonetablethree)
    guest_number = 2
    
    reservation = reservations(:reservationsampletwo)
    reservation.update({
      table_id: table.id,
      guest_number: guest_number,
      booking_time: "2018-04-08 13:00:00",
    })

    assert_equal "there is no available shift", reservation.errors.messages[:base].first    
  end  

  test "guest can't update reservation because overlap" do
    guest = guests(:jane)
    table = tables(:restaurantonetableone)
    guest_number = 2
    
    reservation = reservations(:reservationsampletwo)
    reservation.update({
      table_id: table.id,
      guest_number: guest_number,
      booking_time: "2018-04-08 09:30:00",
    })

    assert_equal "table not available", reservation.errors.messages[:base].first    
  end    
end
